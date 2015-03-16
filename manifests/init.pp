# Copyright 2013 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Class to install elasticsearch.
#
class elasticsearch (
  $version = '0.20.5',
  $heap_size = '16g',
  $es_template_config = {}
) {
  # Ensure: java runtime and curl
  # Curl is handy for talking to the ES API on localhost. Allows for
  # querying cluster state and deleting indexes and so on.
  ensure_packages(['openjdk-7-jre-headless', 'curl'])

  include '::archive'

  $file_name = "elasticsearch-${version}.deb"
  $source_url = "https://download.elasticsearch.org/elasticsearch/elasticsearch/${file_name}"
  $source_checksum = "${source_url}.sha1.txt"

  $checksum = inline_template('<%= require "open-uri"; open(@source_checksum).read.split.first %>')

  archive { "/tmp/elasticsearch-${version}.deb":
    source        => $source_url,
    extract       => false,
    checksum      => $checksum,
    checksum_type => 'sha1',
  }

  # install elastic search
  package { 'elasticsearch':
    ensure   => latest,
    source   => "/tmp/elasticsearch-${version}.deb",
    provider => 'dpkg',
    require  => [
      Package['openjdk-7-jre-headless'],
      Archive["/tmp/elasticsearch-${version}.deb"],
    ]
  }

  file { '/etc/elasticsearch':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/elasticsearch/elasticsearch.yml':
    ensure  => present,
    content => template('elasticsearch/elasticsearch.yml.erb'),
    replace => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/elasticsearch'],
  }

  file { '/etc/elasticsearch/templates':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/elasticsearch'],
  }

  file { '/etc/elasticsearch/default-mapping.json':
    ensure  => present,
    source  => 'puppet:///modules/elasticsearch/elasticsearch.mapping.json',
    replace => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/elasticsearch'],
  }

  file { '/etc/default/elasticsearch':
    ensure  => present,
    content => template('elasticsearch/elasticsearch.default.erb'),
    replace => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}

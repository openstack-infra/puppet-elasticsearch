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
  $checksum = undef,
  $url = 'https://download.elasticsearch.org/elasticsearch/elasticsearch',
  $heap_size = '16g',
  $es_template_config = {},
) inherits elasticsearch::params {
  # Ensure: java runtime and curl
  # Curl is handy for talking to the ES API on localhost. Allows for
  # querying cluster state and deleting indexes and so on.
  ensure_packages(['openjdk-7-jre-headless', 'curl', $::elasticsearch::params::gem_package])

  include '::archive'

  $package_name = "elasticsearch-${version}.deb"
  $source_url = "${url}/${package_name}"
  $source_checksum = "${source_url}.sha1.txt"

  if $checksum {
    $es_checksum = $checksum
  } else {
    $es_checksum = es_checksum($source_checksum)
  }

  if $es_checksum {
    $checksum_type = 'sha1'
  } else {
    $checksum_type = 'none'
  }

  archive { "/tmp/elasticsearch-${version}.deb":
    source        => $source_url,
    extract       => false,
    checksum      => $es_checksum,
    checksum_type => $checksum_type,
  }

  # install elastic search
  package { 'elasticsearch':
    ensure   => latest,
    source   => "/tmp/elasticsearch-${version}.deb",
    provider => 'dpkg',
    require  => [
      Package['openjdk-7-jre-headless'],
      File['/etc/elasticsearch/elasticsearch.yml'],
      File['/etc/elasticsearch/default-mapping.json'],
      File['/etc/default/elasticsearch'],
      Archive["/tmp/elasticsearch-${version}.deb"],
    ]
  }

  if 'path.data' in $es_template_config {
    file { $es_template_config['path.data']:
      ensure  => directory,
      owner   => 'elasticsearch',
      require => Package['elasticsearch'],
    }
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
  }

  file { '/etc/elasticsearch/templates':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/elasticsearch/default-mapping.json':
    ensure  => present,
    source  => 'puppet:///modules/elasticsearch/elasticsearch.mapping.json',
    replace => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/default/elasticsearch':
    ensure  => present,
    content => template('elasticsearch/elasticsearch.default.erb'),
    replace => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  cron { 'cleanup-es-logs':
    command     => 'find /var/log/elasticsearch -type f -mtime +14 -delete',
    user        => 'root',
    hour        => '6',
    minute      => '7',
    environment => 'PATH=/usr/bin:/bin:/usr/sbin:/sbin',
    require     => Package['elasticsearch'],
  }
}

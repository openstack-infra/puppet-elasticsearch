require 'spec_helper'

describe 'elasticsearch' do
  context 'default' do
    let(:package_name) { 'elasticsearch-0.20.5.deb' }
    it {
      should contain_package('openjdk-7-jre-headless')
      should contain_package('curl')
    }
    it { should contain_class('archive') }
    it {
      should contain_archive("/tmp/#{package_name}").with({
        'source'  => "https://download.elasticsearch.org/elasticsearch/elasticsearch/#{package_name}",
        'extract' => false,
      })
    }
    it {
      should contain_package('elasticsearch').with({
        'ensure'   => 'latest',
        'source'   => "/tmp/#{package_name}",
        'provider' => 'dpkg',
      })
    }
    it {
      should contain_file('/etc/elasticsearch')
      should contain_file('/etc/elasticsearch/elasticsearch.yml')
      should contain_file('/etc/elasticsearch/templates')
      should contain_file('/etc/elasticsearch/default-mapping.json')
      should contain_file('/etc/default/elasticsearch')
    }
  end

  context 'with params' do
    let(:params) {{
      :version => '1.5.0',
      :url => 'https://myserver/es'
    }}

    let(:package_name) { 'elasticsearch-1.5.0.deb' }

    it {
      should contain_package('openjdk-7-jre-headless')
      should contain_package('curl')
    }
    it { should contain_class('archive') }
    it {
      should contain_archive("/tmp/#{package_name}").with({
        'source'  => "https://myserver/es/#{package_name}",
        'extract' => false,
      })
    }
    it {
      should contain_package('elasticsearch').with({
        'ensure'   => 'latest',
        'source'   => "/tmp/#{package_name}",
        'provider' => 'dpkg',
      })
    }
  end
end

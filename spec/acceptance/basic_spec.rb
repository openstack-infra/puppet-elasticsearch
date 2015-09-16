require 'spec_helper_acceptance'

describe 'puppet-elasticsearch module', :if => ['debian', 'ubuntu'].include?(os[:family]) do
  def pp_path
    base_path = File.dirname(__FILE__)
    File.join(base_path, 'fixtures')
  end

  def default_puppet_module
    module_path = File.join(pp_path, 'default.pp')
    File.read(module_path)
  end

  it 'should work with no errors' do
    apply_manifest(default_puppet_module, catch_failures: true)
  end

  it 'should be idempotent' do
    pending('this module is not idempotent yet')
    apply_manifest(default_puppet_module, catch_changes: true)
  end

  describe 'required packages' do
    describe package('curl') do
      it { should be_installed }
    end

    describe package('openjdk-7-jre-headless') do
      it { should be_installed }
    end

    describe package('elasticsearch') do
      it { should be_installed }
    end
  end

  describe 'required files' do
    describe file('/etc/elasticsearch/elasticsearch.yml') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should include 'cluster.name: acceptance-test' }
    end

    describe file('/etc/elasticsearch/templates') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/elasticsearch/default-mapping.json') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should include '"_source": { "compress": true },' }
    end

    describe file('/etc/default/elasticsearch') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should include 'ES_HEAP_SIZE=16g' }
    end

    describe file('/tmp/acceptance') do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end
  end

  describe cron do
    it { should have_entry('7 6 * * * find /var/log/elasticsearch -type f -mtime +14 -delete').with_user('root') }
  end
end

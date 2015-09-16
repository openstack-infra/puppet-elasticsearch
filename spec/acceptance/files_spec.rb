require 'spec_helper_acceptance'

describe 'required files', :if => ['debian', 'ubuntu'].include?(os[:family]) do
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

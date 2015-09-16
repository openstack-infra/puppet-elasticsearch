require 'spec_helper_acceptance'

describe 'required packages' do
  describe package('curl') do
    it { should be_installed }
  end

  describe package('openjdk-7-jre-headless') do
    it { should be_installed }
  end

  describe package('elasticsearch') do
    it { should be_installed.with_version('0.20.5') }
  end
end

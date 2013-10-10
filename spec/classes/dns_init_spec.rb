require 'spec_helper'

describe 'dns' do

  let(:facts) do
    {
      :osfamily   => 'RedHat',
      :fqdn => 'puppetmaster.example.com',
      :clientcert => 'puppetmaster.example.com',
    }
  end

  describe 'with no custom parameters' do
    it { should include_class('dns::install') }
    it { should include_class('dns::config') }
    it { should include_class('dns::service') }

    it { should contain_file('/var/named/puppetstore').with_ensure('directory') }
    it { should contain_file('/etc/named/options.conf') }
    it { should contain_file('/var/named/dynamic').with_ensure('directory') }
    it { should contain_file('/etc/named.conf') }
    it { should contain_package('dns').with_ensure('present').with_name('bind') }
  end

end

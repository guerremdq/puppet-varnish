require 'spec_helper'

describe 'varnish' do

  context 'Supported OS - ' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "#{osfamily} Standard installation" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_package('varnish').with_ensure('present') }
      end

      describe "#{osfamily} Installation of a specific package version" do
        let(:params) { {
          :version => '1.0.42',
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_package('varnish').with_ensure('1.0.42') }
      end

      describe "#{osfamily} Removal of package installation" do
        let(:params) { {
          :ensure => 'absent',
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it 'should remove Package[varnish]' do should contain_package('varnish').with_ensure('absent') end
        it 'should remove varnish configuration file' do should contain_file('varnish.conf').with_ensure('absent') end
      end

      describe "#{osfamily} Configuration via custom template" do
        let(:params) { {
          :config_file_template     => 'varnish/spec.conf',
          :config_file_options_hash => { 'opt_a' => 'value_a' },
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_file('varnish.conf').with_content(/This is a template used only for rspec tests/) }
        it 'should generate a template that uses custom options' do
          should contain_file('varnish.conf').with_content(/value_a/)
        end
      end

      describe "#{osfamily} Configuration via custom source file" do
        let(:params) { {
          :config_file_source => "puppet:///modules/varnish/spec.conf",
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_file('varnish.conf').with_source('puppet:///modules/varnish/spec.conf') }
      end

      describe "#{osfamily} Configuration via custom source dir" do
        let(:params) { {
          :config_dir_source => 'puppet:///modules/varnish/tests/',
          :config_dir_purge => true
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_file('varnish.dir').with_source('puppet:///modules/varnish/tests/') }
        it { should contain_file('varnish.dir').with_purge('true') }
        it { should contain_file('varnish.dir').with_force('true') }
      end

    end
  end

  context 'Unsupported OS - ' do
    describe 'Not supported operating systems should throw and error' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end

end


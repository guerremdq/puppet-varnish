require 'spec_helper_system'

describe 'install:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'varnish': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test varnish' do
    pp = fixture_read('modules/varnish/tests/init.pp')

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end

    puppet_apply(pp) do |r|
      r.exit_code.should be_zero
    end
  end

end

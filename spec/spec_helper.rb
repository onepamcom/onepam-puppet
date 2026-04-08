require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

RSpec.configure do |c|
  c.default_facts = {
    kernel: 'Linux',
    os: {
      'family'       => 'Debian',
      'name'         => 'Ubuntu',
      'architecture' => 'x86_64',
      'release'      => { 'major' => '22', 'full' => '22.04' },
    },
  }
end

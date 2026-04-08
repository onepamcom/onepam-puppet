require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks' if Bundler.rubygems.find_name('puppet-blacksmith').any?

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.ignore_paths = ['spec/**/*.pp', 'pkg/**/*.pp', 'vendor/**/*.pp']

PuppetSyntax.exclude_paths = ['spec/**/*.pp', 'pkg/**/*.pp', 'vendor/**/*.pp']

desc 'Validate manifests, templates, and ruby files'
task :validate do
  Rake::Task['syntax'].invoke
end

desc 'Run all checks and tests'
task default: [:validate, :lint, :spec]


# frozen_string_literal: false

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utf8_sanitizer'
require 'utf8_sanitizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'utf8_sanitizer'
  spec.version       = Utf8Sanitizer::VERSION
  spec.authors       = ['Adam Booth']
  spec.email         = ['4rlm@protonmail.ch']
  spec.homepage      = 'https://github.com/4rlm/utf8_sanitizer'
  spec.license       = 'MIT'

  spec.summary       = "Still in Development: Removes invalid UTF8 characters, and extra whitespace (carriage returns, new lines, tabs, spaces, etc.) from csv, or strings."
  spec.description   = "Removes invalid UTF8 characters, and extra whitespace (carriage returns, new lines, tabs, spaces, etc.) from csv, or strings. Example: ABC Au\xC1tos,123 E Main St,Anytown,TX,75142,(888) 457-4391\n\r\n => ABC Autos,123 E Main St,Anytown,TX,75142,(888) 457-4391"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  # spec.post_install_message = "Thanks for installing!"

  spec.required_ruby_version = '~> 2.5.1'
  spec.add_dependency 'activesupport', '~> 5.2.0'
  # spec.add_dependency "activesupport-inflector", ['~> 0.1.0']
  # spec.executables << 'rake', '~> 10.4.2'
  # spec.extra_rdoc_files = ['README', 'doc/user-guide.txt']

  # spec.add_runtime_dependency 'library', '~> 2.2'
  # spec.add_dependency "activesupport-inflector", ['~> 0.1.0']
  # spec.add_dependency 'activesupport', '>= 3.0'
  # spec.add_dependency 'activerecord', '>= 3.0'
  # spec.required_ruby_version = ">= 2.3.0"
  # spec.add_dependency 'actionpack', '>= 3.0'
  # spec.add_dependency 'i18n'
  # spec.add_dependency 'polyamorous', '~> 1.3.2'
  # spec.add_development_dependency 'rspec', '~> 3'
  # spec.add_development_dependency 'machinist', '~> 1.0.6'
  # spec.add_development_dependency 'faker', '~> 0.9.5'
  # spec.add_development_dependency 'sqlite3', '~> 1.3.3'
  # spec.add_development_dependency 'pg', '~> 0.21'
  # spec.add_development_dependency 'mysql2', '0.3.20'
  # spec.add_development_dependency 'pry', '0.10'

  spec.add_development_dependency 'bundler', '>= 1.14.0'
  spec.add_development_dependency 'byebug', '~> 10.0', '>= 10.0.2'
  spec.add_development_dependency 'class_indexer', '~> 0.2.0'
  spec.add_development_dependency 'irbtools'
  spec.add_development_dependency 'rake', '>= 11.5.1'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'rubocop', '~> 0.56.0'
  spec.add_development_dependency 'ruby-beautify', '~> 0.97.4'
  # spec.add_development_dependency "pry", "~> 0.11.3"

  # spec.requirements << 'libmagick, v6.0'
  # spec.requirements << 'A good graphics card'

  # # This gem will work with 1.8.6 or greater...
  # spec.required_ruby_version = '>= 1.8.6'
  #
  # # Only with ruby 2.0.x
  # spec.required_ruby_version = '~> 2.0'
  #
  # # Only with ruby between 2.2.0 and 2.2.2
  # spec.required_ruby_version = ['>= 2.2.0', '< 2.2.3']
end

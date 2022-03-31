require_relative 'lib/bra_document_validation/version'

Gem::Specification.new do |spec|
  spec.name          = 'bra_document_validation'
  spec.version       = BraDocumentValidation::VERSION
  spec.authors       = ['Bruno Vicenzo']
  spec.email         = ['bruno@alumni.usp.br']

  spec.summary       = %q{This gem add ActiveModel validations to Brazilian documents.}
  spec.description   = %q{We can validate CPF and CNPJ formats and verifying digits.}
  spec.homepage      = 'https://github.com/bvicenzo/bra_document_validation'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/bvicenzo/bra_document_validation/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activemodel', '>= 4.0'
  spec.add_runtime_dependency 'bra_documents', '>= 1.0.1'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end

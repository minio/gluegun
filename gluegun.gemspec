# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gluegun/version"

Gem::Specification.new do |spec|
  spec.name          = "gluegun"
  spec.version       = Gluegun::VERSION
  spec.authors       = ["minio"]
  spec.email         = ["sysadmin@minio.io"]
  spec.license       = "Apache-2.0"
  spec.summary       = %q{Gluegun is glues markdown docs from github and creates a beautiful docs site.}
  spec.description   = %q{Gluegun is glues markdown docs from github and pulls together a beautiful docs site. }
  spec.homepage      = "https://github.com/minio/gluegun"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    #spec.metadata["allowed_push_host"] = "'https://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.4"

  spec.post_install_message = %q{
    Generate sites using:  `./gluegun generate site.yml`
    For more details see https://gluegun.minio.io
  }

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'github-markdown', "~> 0"
end

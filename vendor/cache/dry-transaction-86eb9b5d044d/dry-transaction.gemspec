# -*- encoding: utf-8 -*-
# stub: dry-transaction 0.10.2 ruby lib

Gem::Specification.new do |s|
  s.name = "dry-transaction".freeze
  s.version = "0.10.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tim Riley".freeze]
  s.date = "2017-09-06"
  s.email = ["tim@icelab.com.au".freeze]
  s.files = ["Gemfile".freeze, "LICENSE.md".freeze, "README.md".freeze, "Rakefile".freeze, "lib/dry".freeze, "lib/dry-transaction.rb".freeze, "lib/dry/transaction".freeze, "lib/dry/transaction.rb".freeze, "lib/dry/transaction/builder.rb".freeze, "lib/dry/transaction/dsl.rb".freeze, "lib/dry/transaction/instance_methods.rb".freeze, "lib/dry/transaction/operation.rb".freeze, "lib/dry/transaction/operation_resolver.rb".freeze, "lib/dry/transaction/result_matcher.rb".freeze, "lib/dry/transaction/step.rb".freeze, "lib/dry/transaction/step_adapters".freeze, "lib/dry/transaction/step_adapters.rb".freeze, "lib/dry/transaction/step_adapters/map.rb".freeze, "lib/dry/transaction/step_adapters/raw.rb".freeze, "lib/dry/transaction/step_adapters/tee.rb".freeze, "lib/dry/transaction/step_adapters/try.rb".freeze, "lib/dry/transaction/step_failure.rb".freeze, "lib/dry/transaction/version.rb".freeze, "spec/integration".freeze, "spec/integration/custom_step_adapters_spec.rb".freeze, "spec/integration/operation_spec.rb".freeze, "spec/integration/passing_step_arguments_spec.rb".freeze, "spec/integration/publishing_step_events_spec.rb".freeze, "spec/integration/transaction_spec.rb".freeze, "spec/integration/transaction_without_steps_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/support/either_mixin.rb".freeze, "spec/support/test_module_constants.rb".freeze, "spec/unit".freeze, "spec/unit/step_adapters".freeze, "spec/unit/step_adapters/map_spec.rb".freeze, "spec/unit/step_adapters/raw_spec.rb".freeze, "spec/unit/step_adapters/tee_spec.rb".freeze, "spec/unit/step_adapters/try_spec.rb".freeze, "spec/unit/step_spec.rb".freeze]
  s.homepage = "https://github.com/dry-rb/dry-transaction".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0".freeze)
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Business Transaction Flow DSL".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dry-container>.freeze, [">= 0.2.8"])
      s.add_runtime_dependency(%q<dry-matcher>.freeze, [">= 0.5.0"])
      s.add_runtime_dependency(%q<dry-monads>.freeze, [">= 0.0.1"])
      s.add_runtime_dependency(%q<wisper>.freeze, [">= 1.6.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.15"])
      s.add_development_dependency(%q<rake>.freeze, [">= 11.2.2", "~> 11.2"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.3"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<yard>.freeze, [">= 0"])
    else
      s.add_dependency(%q<dry-container>.freeze, [">= 0.2.8"])
      s.add_dependency(%q<dry-matcher>.freeze, [">= 0.5.0"])
      s.add_dependency(%q<dry-monads>.freeze, [">= 0.0.1"])
      s.add_dependency(%q<wisper>.freeze, [">= 1.6.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.15"])
      s.add_dependency(%q<rake>.freeze, [">= 11.2.2", "~> 11.2"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<yard>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<dry-container>.freeze, [">= 0.2.8"])
    s.add_dependency(%q<dry-matcher>.freeze, [">= 0.5.0"])
    s.add_dependency(%q<dry-monads>.freeze, [">= 0.0.1"])
    s.add_dependency(%q<wisper>.freeze, [">= 1.6.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.15"])
    s.add_dependency(%q<rake>.freeze, [">= 11.2.2", "~> 11.2"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
  end
end

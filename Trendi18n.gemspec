# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Trendi18n}
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Piotr Misiurek"]
  s.date = %q{2009-12-05}
  s.description = %q{Some description}
  s.email = %q{p.misiurek@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "Trendi18n.gemspec",
     "VERSION",
     "app/models/translation.rb",
     "generators/trendi18n/templates/migrations/create_translations.rb",
     "generators/trendi18n/trendi18n_generator.rb",
     "init.rb",
     "install.rb",
     "lib/commands.rb",
     "lib/file.rb",
     "lib/trendi18n.rb",
     "spec/test_application/.gitignore",
     "spec/test_application/README",
     "spec/test_application/Rakefile",
     "spec/test_application/app/controllers/application_controller.rb",
     "spec/test_application/app/helpers/application_helper.rb",
     "spec/test_application/app/views/layouts/application.rhtml",
     "spec/test_application/app/views/users/index.rhtml",
     "spec/test_application/config/boot.rb",
     "spec/test_application/config/database.yml",
     "spec/test_application/config/environment.rb",
     "spec/test_application/config/environments/cucumber.rb",
     "spec/test_application/config/environments/development.rb",
     "spec/test_application/config/environments/production.rb",
     "spec/test_application/config/environments/test.rb",
     "spec/test_application/config/initializers/new_rails_defaults.rb",
     "spec/test_application/config/initializers/session_store.rb",
     "spec/test_application/config/locales/en.yml",
     "spec/test_application/config/routes.rb",
     "spec/test_application/db/development.sqlite3",
     "spec/test_application/db/migrate/20091109171526_create_translations.rb",
     "spec/test_application/db/schema.rb",
     "spec/test_application/db/seeds.rb",
     "spec/test_application/doc/README_FOR_APP",
     "spec/test_application/features/dynamic_translation.feature",
     "spec/test_application/features/managing_translations.feature",
     "spec/test_application/features/static_translation.feature",
     "spec/test_application/features/step_definitions/webrat_steps.rb",
     "spec/test_application/features/support/env.rb",
     "spec/test_application/features/support/paths.rb",
     "spec/test_application/features/support/version_check.rb",
     "spec/test_application/lib/tasks/cucumber.rake",
     "spec/test_application/lib/tasks/rspec.rake",
     "spec/test_application/public/404.html",
     "spec/test_application/public/422.html",
     "spec/test_application/public/500.html",
     "spec/test_application/public/favicon.ico",
     "spec/test_application/public/images/rails.png",
     "spec/test_application/public/javascripts/application.js",
     "spec/test_application/public/javascripts/controls.js",
     "spec/test_application/public/javascripts/dragdrop.js",
     "spec/test_application/public/javascripts/effects.js",
     "spec/test_application/public/javascripts/prototype.js",
     "spec/test_application/public/robots.txt",
     "spec/test_application/script/about",
     "spec/test_application/script/autospec",
     "spec/test_application/script/console",
     "spec/test_application/script/cucumber",
     "spec/test_application/script/dbconsole",
     "spec/test_application/script/destroy",
     "spec/test_application/script/generate",
     "spec/test_application/script/performance/benchmarker",
     "spec/test_application/script/performance/profiler",
     "spec/test_application/script/plugin",
     "spec/test_application/script/runner",
     "spec/test_application/script/server",
     "spec/test_application/script/spec",
     "spec/test_application/spec/backend_spec.rb",
     "spec/test_application/spec/models/translation_spec.rb",
     "spec/test_application/spec/rcov.opts",
     "spec/test_application/spec/spec.opts",
     "spec/test_application/spec/spec_helper.rb",
     "spec/test_application/test/functional/application_controller_test.rb",
     "spec/test_application/test/unit/helpers/application_helper_test.rb",
     "tasks/trendi18n_tasks.rake",
     "uninstall.rb"
  ]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Database backend for i18n}
  s.test_files = [
    "spec/test_application/app/controllers/application_controller.rb",
     "spec/test_application/app/helpers/application_helper.rb",
     "spec/test_application/config/boot.rb",
     "spec/test_application/config/environment.rb",
     "spec/test_application/config/environments/cucumber.rb",
     "spec/test_application/config/environments/development.rb",
     "spec/test_application/config/environments/production.rb",
     "spec/test_application/config/environments/test.rb",
     "spec/test_application/config/initializers/new_rails_defaults.rb",
     "spec/test_application/config/initializers/session_store.rb",
     "spec/test_application/config/routes.rb",
     "spec/test_application/db/migrate/20091109171526_create_translations.rb",
     "spec/test_application/db/schema.rb",
     "spec/test_application/db/seeds.rb",
     "spec/test_application/features/step_definitions/webrat_steps.rb",
     "spec/test_application/features/support/env.rb",
     "spec/test_application/features/support/paths.rb",
     "spec/test_application/features/support/version_check.rb",
     "spec/test_application/spec/models/translation_spec.rb",
     "spec/test_application/spec/spec_helper.rb",
     "spec/test_application/spec/backend_spec.rb",
     "spec/test_application/test/functional/application_controller_test.rb",
     "spec/test_application/test/unit/helpers/application_helper_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end


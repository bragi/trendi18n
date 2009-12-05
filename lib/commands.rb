require "rails_generator"
require "rails_generator/commands"

module Trendi18n
  module Generator
    module Commands

      module Create

        def installer
            puts "Creating migration file..."
            migration_template(File.join("migrations", "create_translations.rb"), File.join("db", "migrate"),
              :migration_file_name => ActiveRecord::Base.pluralize_table_names ? "create_translations" : "create_translation")
            puts "Inserting migration into db..."
            version = File.get_migration_version_from_file_name(ActiveRecord::Base.pluralize_table_names ? /create_translations\.rb$/ : /create_translation\.rb$/)
            system "rake db:migrate:up VERSION=#{version}"
        end

      end

      module Destroy

         def installer
            puts "Removing migration from db..."
            version = File.get_migration_version_from_file_name(ActiveRecord::Base.pluralize_table_names ? /create_translations\.rb$/ : /create_translation\.rb$/)
            system "rake db:migrate:down VERSION=#{version}"
            puts "Removing migration file..."
            migration_template(File.join("migrations", "create_translations.rb"), File.join("db", "migrate"),
              :migration_file_name => ActiveRecord::Base.pluralize_table_names ? "create_translations" : "create_translation")
        end

      end

    end
  end
end

 Rails::Generator::Commands::Create.send :include, Trendi18n::Generator::Commands::Create
 Rails::Generator::Commands::Destroy.send :include, Trendi18n::Generator::Commands::Destroy
class File

   # get migration version from filename matching to regexp
  def self.get_migration_version_from_file_name(migration_name_regexp)
    Dir[File.join("db", "migrate", "*.rb")].each { |file| return File.basename(file).split("_")[0].to_i if migration_name_regexp.match(File.basename(file)) }
  end

end
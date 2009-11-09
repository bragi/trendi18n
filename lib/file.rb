class File

  
  
  def self.exist_any?(path, regexp)
    # return true if in path exist any file matchin to regexp
    Dir[path].each { |file| return true if regexp.match(File.basename(file))}
    false
  end

  def self.get_migration_version_from_file_name(migration_name_regexp)
    Dir[File.join("db", "migrate", "*.rb")].each { |file| return File.basename(file).split("_")[0].to_i if migration_name_regexp.match(File.basename(file)) }
  end


end
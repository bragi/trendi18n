class Trendi18nGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.installer
    end
  end
end
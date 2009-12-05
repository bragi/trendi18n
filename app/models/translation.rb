class Translation < ActiveRecord::Base
  before_validation :set_status
  before_validation :set_defaults


  validates_presence_of :key
  validates_length_of :locale, :within => 2..6
  validates_uniqueness_of :key, :scope => %w(locale scope)

  @@locales = nil

  def self.locales
    # return locales if their exists and translations are up-to-date. In other case assign are locales values from db to locales and return this value
    @@locales.nil? && self.up_to_date? ? @@locales : @@locales = self.find(:all, :select => "distinct(locale", :order => "locale ASC").map(&:locale)
  end

  def self.find_by_string_normalized_key(key)
    # auto-magic finder using string normalized key to find translation. The first value in scope is the locale, the last is the key and all between are scopes
    scope = I18n.send(:normalize_translation_keys, I18n.locale, key, nil).map(&:to_s)
    self.first(:conditions => {:key => scope.last, :locale => scope.first, :scope => scope[1..-2].empty? ? nil : scope[1..-2].join(".") }) || raise(ActiveRecord::RecordNotFound, "Could not find translation with key #{key}")
  end


  def set_status
    # Assign status to translation
    # - if there is no count in the key, set new if there is not translation and set finished when translation exists
    # - if there is count in the key, then:
    #   * if translation has all plural forms, assign finished
    #   * if translation has some plural forms, then assign unfinished
    #   * if translation does not have plural forms, then assign new
    self.status = self.with_count? ? self.has_all_plural_forms? ? "finished" : self.has_some_plural_forms? ? "unfinished" : "new" : self.translation.blank? ? "new" : "finished"
  end

  def set_defaults
    # assign default values to translation
    self.locale = I18n.locale.to_s if self.locale.nil? # if translation does not have locale, set I18n default
    self.default = key unless self.default # set key to default if it is not exists
    self.scope = nil if self.scope.blank? #set nil to scope if it is blank (empty string)
  end

  def self.base_updated_at
    # time of the last db update
    self.exists?(["updated_at > created_at"]) ? self.first(:order => "updated_at DESC", :conditions => "updated_at > created_at").updated_at : Time.at(0)
  end

  def self.read_base
    # time of the db read on current db update
    @base_read_at = Time.zone.now if @base_read_at.nil?
  end

  def self.clear_base_read_at
    @base_read_at = nil
  end

  def self.update_base
    @base_read_at = nil
  end

  def self.up_to_date?
    # db is up-to-date when it wasn't read or read time is larger then update time
    @base_read_at.nil? || @base_read_at.to_i > self.base_updated_at.to_i
  end


  def with_count?
    # don't be nil if there is "{{count}}" in key
    /\{\{count\}\}/.match(self.key)
  end

  def has_all_plural_forms?
    # true if translation has all plural forms
    !self.zero.blank? && !self.one.blank? && !self.many.blank?
  end

  def pluralize(count)
    # get correct pluralization form (using count)
    if count
      case count
      when 0 then self.zero
      when 1 then self.one
      else self.many
        end || self.default
    else
      self.translation || self.default
    end
  end

  def has_some_plural_forms?
    # true if translation has some plural forms
    !self.zero.blank? || !self.one.blank? || !self.many.blank?
  end

  def self.lookup(locale, key, default = nil, scope = nil)
    # look up for translation and return it, if exists, or create if not
    self.read_base
    scope = I18n.send(:normalize_translation_keys, locale, key, scope)
    locale = scope.delete_at(0).to_s
    key = scope.delete_at(scope.size - 1).to_s
    scope = scope.empty? ? nil : scope.join(".")
    if self.exists?(:locale => locale, :scope => scope, :key => key)
      translation = self.first(:conditions => {:locale => locale, :scope => scope, :key => key})
    else
      translation = self.new(:key => key, :default => default.nil? ? key : default, :locale => locale, :scope => scope)
      translation.save
    end
    translation
  end

  def to_translation_hash
    # return hash ready to by stored as translation
   path = self.scope.nil? ? [self.key] : self.scope.split(".") << self.key
   return path.reverse.inject(self) {|before, step| { step => before}}
  end

end

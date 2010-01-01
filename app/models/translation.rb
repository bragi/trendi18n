class Translation < ActiveRecord::Base
  before_validation :set_state
  before_validation :set_defaults

  named_scope :untranslated, :conditions => {:state => %w(new unfinished)}
  named_scope :translated, :conditions => {:state => "finished"}
  named_scope :localization, lambda {|*args| args.first ? {:conditions => {:locale => args.first}} : nil }

  validates_presence_of :key
  validates_length_of :locale, :within => 2..6
  validates_uniqueness_of :key, :scope => %w(locale scope)

  @@locales = []

  # return true if there is no translation with key == name, and there is some translations with scope == name
  def self.scope?(name, locale = I18n.default_locale.to_s)
    !self.exists?(:key => name, :locale => locale, :scope => nil) && self.exists?(:scope => name, :locale => locale)
  end

   # return locales which translations are stored in db
  def self.get_locales
    @@locales
  end

  # read locales which translation are stored in db
  def self.set_locales
    @@locales = self.all(:select => "DISTINCT(locale)", :order => "locale ASC").map { |obj| obj.locale  }
  end

  # Set @read_time, date and time of first database read on current update.
  # @read_time is used to get translations cache up-to-date status
  def self.set_read_time
    @read_time = Time.zone.now if @read_time.nil?
  end

  # Clear value of @read_time. It is used durnig backend reload!
  def self.clear_read_time
    @read_time = nil
  end

  # Return date and time of last translations update in database. It is used to get
  # translations cache up-to-date status and we need to reload backend only after
  # update existing translations (new translations will be cached when they will be used
  # first time), so we are looking for the biggest update time in translations that
  # updated_at is greater then created_at
  def self.update_time
    self.exists?(["updated_at > created_at"]) ? self.first(:conditions => "updated_at > created_at", :order => "updated_at DESC").updated_at : Time.zone.at(0)
  end

  def self.update_locales_time
    self.exists? ? self.first(:order => "updated_at DESC").updated_at : Time.zone.at(0)
  end

  # Checking translations cache up-to-date status. We need to reload backend when
  # cache is not up-to-date. It's going on when so existing translation was updated.
  # We can't reload backend using after_update callback becouse there can be many
  # proccesses running our apps and all of them must be reloaded, not only the updater.
  def self.up_to_date?
    @read_time.nil? ? true : self.update_time.to_i < @read_time.to_i
  end

  def self.locales_up_to_date?
    @read_time.nil? ? true : self.update_locales_time.to_i < @read_time.to_i
  end

  # auto-magic finder using string normalized key to find translation. The first value in scope is the locale, the last is the key and all between are scopes
  def self.find_by_string_normalized_key(key)
    scope = I18n.send(:normalize_translation_keys, I18n.locale, key, nil).map(&:to_s)
    self.first(:conditions => {:key => scope.last, :locale => scope.first, :scope => scope[1..-2].empty? ? nil : scope[1..-2].join(".") }) || raise(ActiveRecord::RecordNotFound, "Could not find translation with key #{key}")
  end

  # Assign state of translation
    # - if there is no count in the key, set new if there is not translation and set finished when translation exists
    # - if there is count in the key, then:
    #   * if translation has all plural forms, assign finished
    #   * if translation has some plural forms, then assign unfinished
    #   * if translation does not have plural forms, then assign new
  def set_state
    self.state = self.with_count? ? self.has_all_plural_forms? ? "finished" : self.has_some_plural_forms? ? "unfinished" : "new" : self.translation.blank? ? "new" : "finished"
  end

  # assign default values to translation
  def set_defaults
    self.locale = I18n.locale.to_s if self.locale.blank? # if translation does not have locale, set I18n default
    self.default = key unless self.default # set key to default if it is not exists
    self.scope = nil if self.scope.blank? #set nil to scope if it is blank (empty string)
    self.translation = nil if self.translation.blank? # set nil to translation if it is blank (empty string)
  end

  # don't be nil if there is "{{count}}" in key
  def with_count?
    /\{\{count\}\}/.match(self.key)
  end

  # true if translation has all plural forms
  def has_all_plural_forms?
    !self.zero.blank? && !self.one.blank? && !self.many.blank?
  end

  # get correct pluralization form (using count)
  def pluralize(count)
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

  # true if translation has some plural forms
  def has_some_plural_forms?
    !self.zero.blank? || !self.one.blank? || !self.many.blank?
  end

  # look up for translation and return it, if exists, or create if not
  def self.lookup(locale, key, default = nil, scope = nil)
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

  # return hash ready to by stored as translation
  def to_translation_hash()
   path = []
   path += self.scope.split(".") unless self.scope.nil?
   path << self.key
   return path.reverse.inject(self) {|before, step| { step => before}}
  end

  # return ready to by stored as translations hash of translations in scope
  def self.scope_to_translation_hash(scope, locale = I18n.default_locale.to_s)
    children = self.all(:conditions => {:scope => scope, :locale => locale}, :order => "key")
    hash = {}
    for child in children
      hash.deep_merge!  child.to_translation_hash()
    end
    Trendi18n::ScopeTranslations.new(locale, hash)
  end

end

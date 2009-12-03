class Translation < ActiveRecord::Base
  before_validation :set_status
  before_validation :set_defaults


  validates_presence_of :key
  validates_length_of :locale, :within => 2..6
  validates_uniqueness_of :key, :scope => %w(locale scope)

  @@locales = nil

  def self.locales
    @@locales unless @@locales.nil? && self.up_to_date?
    @@locales = self.find(:all, :select => "distinct(locale", :order => "locale ASC").map(&:locale)
  end

   def self.find_by_string_normalized_key(key)
    scope = I18n.send(:normalize_translation_keys, I18n.locale, key, nil).map(&:to_s)
    self.first(:conditions => {:key => scope.last, :locale => scope.first, :scope => scope[1..-2].empty? ? nil : scope[1..-2].join(".") }) || raise(ActiveRecord::RecordNotFound, "Could not find translation with key #{key}")
  end


  def set_status
    self.status = self.with_count? ? self.has_all_plural_forms? ? "finished" : self.has_some_plural_forms? ? "unfinished" : "new" : self.translation.blank? ? "new" : "finished"
  end

  def set_defaults
    self.locale = I18n.locale.to_s if self.locale.nil?
    self.default = key unless self.default
    self.scope = nil if self.scope.blank?
  end

  def self.base_updated_at
    self.exists?(["updated_at > created_at"]) ? self.first(:order => "updated_at DESC", :conditions => "updated_at > created_at").updated_at : Time.at(0)
  end

  def self.read_base
    @base_read_at = Time.zone.now if @base_read_at.nil?
  end

  def self.clear_base_read_at
    @base_read_at = nil
  end

  def self.update_base
    @base_read_at = nil
  end

  def self.up_to_date?
    @base_read_at.nil? || @base_read_at.to_i > self.base_updated_at.to_i
  end


  def with_count?
    /\{\{count\}\}/.match(self.key)
  end

  def has_all_plural_forms?
    !self.zero.blank? && !self.one.blank? && !self.many.blank?
  end

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

  def has_some_plural_forms?
   !self.zero.blank? || !self.one.blank? || !self.many.blank?
  end

  def self.lookup(locale, key, default = nil, scope = nil)
    self.read_base
    scope = I18n.send(:normalize_translation_keys, locale, key, scope)
    locale = scope.delete_at(0).to_s
    p
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
   path = self.scope.nil? ? [self.key] : self.scope.split(".") << self.key
   return path.reverse.inject(self) {|before, step| { step => before}}
  end

end

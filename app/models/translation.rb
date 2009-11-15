class Translation < ActiveRecord::Base
  before_validation :set_status
  before_validation :set_defaults
  
  validates_inclusion_of :status, :in => %w(new unfinished finished)
  validates_presence_of :key
  validates_presence_of :default
  validates_length_of :locale, :within => 2..6
  validates_uniqueness_of :key, :scope => %w(locale scope)

  @@locales = nil

  def self.locales
    @@locales unless @@locales.nil? && self.up_to_date?
    @@locales = self.find(:all, :select => "distinct(locale", :order => "locale ASC").map(&:locale)
  end
  

  def set_status
    self.status = self.with_count? ? self.has_all_plural_forms? ? "finished" : self.has_some_plural_forms? ? "unfinished" : "new" : self.translation.blank? ? "new" : "finished"
  end

  def set_defaults
    self.locale = I18n.locale.to_s unless self.default
    self.default = key unless self.default
    self.scope = nil if self.scope.blank?
  end

  def self.base_updated_at
    self.first(:order => "updated_at DESC").updated_at
  end

  def self.read_base
    @base_read_at = Time.zone.now
  end

  def self.up_to_date?
    @base_read_at >= self.base_updated_at
  end

  def with_count?
    /\{\{count\}\}/.match(self.key)
  end

  def has_all_plural_forms?
    !self.zero.blank? && !self.one.blank? && !self.many.blank?
  end

  def has_some_plural_forms?
   !self.zero.blank? || !self.one.blank? || !self.many.blank?
  end

  def self.lookup(locale, key, default = nil, scope = nil)
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
   path = self.scope.nil? ? [self.key] : self.scope.split(".") << self.key
   return path.reverse.inject(self) {|before, step| { step => before}}
  end

end

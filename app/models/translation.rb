class Translation < ActiveRecord::Base
  before_validation :set_status
  before_validation :set_defaults
  
  validates_inclusion_of :status, :in => %w(new unfinished finished)
  validates_presence_of :key
  validates_presence_of :default
  validates_length_of :locale, :within => 2..6
  validates_uniqueness_of :key, :scope => %w(locale scope)

  def set_status
    self.status = self.with_count? ? self.has_all_plural_forms? ? "finished" : self.has_some_plural_forms? ? "unfinished" : "new" : self.translation.blank? ? "new" : "finished"
  end

  def set_defaults
    self.locale = I18n.locale.to_s unless self.default
    self.default = key unless self.default
    self.scope = nil if self.scope.blank?
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

end

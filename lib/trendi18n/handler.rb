module Trendi18n
  module Handler

    def self.included(subclass)
      subclass.class_eval do
        before_filter :translations_cache_updater

        # check translations cache up-to-date status and reload backend when needed
        def translations_cache_updater
          I18n.backend.reload! unless I18n.backend.up_to_date?
          I18n.backend.locales_reload! unless I18n.backend.locales_up_to_date?
        end
      end
    end

  end
end

module Trendi18n
  module Backend

    class Trendi18n < I18n::Backend::Simple

      delegate :up_to_date?, :to => Translation
      delegate :locales_up_to_date?, :to => Translation

      # return available locales, based on informaton form Translation model
      def available_locales
        Translation.set_read_time
        Translation.get_locales.collect{|x| x.to_sym} | nested.available_locales
      end

      # translate key in locale using options
      def translate(locale, key, options = {})
        raise InvalidLocale.new(locale) if locale.nil?
        Translation.set_read_time
        #if key is an array then as a result run yourself for all subkey in key
        return key.map { |subkey| translate(locale, subkey, options)} if key.is_a?(Array)

        # read count, scope and default from options
        count, scope, default = options.values_at(:count, :scope, :default)
        options.delete(:default) #delete default from option

        # read values of scope and default options and delete them form options
        values = options.reject {|name, value| [:scope, :default].include?(name)}


        # cache and return all translation from scope if it's used as key
        if Translation.scope?(key_with_scope = [scope, key].delete_if{|x| x.blank?}.join("."), loc = locale.to_s)
          cache_translation(result = Translation.scope_to_translation_hash(key_with_scope, loc))
          return result.to_translation_hash[key.to_s]
        end

        if key.is_a?(Symbol) # if key is a Symbol
          begin
            return nested.translate(locale, key, options) # use nested translete
          rescue
            I18n::MissingTranslationData # if its exists
          end
        end

        entry = lookup(locale, key, default, scope) # lookup for translation
        entry = entry.pluralize(count) # run pluralization for translation
        entry = interpolate(locale, entry, values) # run interpolation for translation
      end

      def reload!
        super
        Translation.clear_read_time
      end

      def locales_reload!
        Translation.set_locales
      end

      protected

      def init_translations
        # only set @initialized. Translations will be caching in real-time
        @initialized = true
        Translation.set_locales
      end

      # look up for translation. When find cache it and return
      def lookup(locale, key, default, scope)
        # cache and return translation. Translation can be find by:
        # - standard I18n::Backend::Simple.lookup method. If its failed, then:
        # - Translation model lookup method
        cache_translation(translation = Translation.lookup(locale, key, default, scope)) unless translation = super(locale, key, scope)
        translation

     end

      private

      # assign new instance of I18n::Backend::Simple for @nested if its not exists
      def nested
        @nested ||= I18n::Backend::Simple.new
      end

      # add translation to stored
      def cache_translation(translation)
        store_translations(translation.locale, translation.to_translation_hash)
      end

      # cache all translations in scope
      def cache_translations_from_scope(scope_translation)
        for hash in scope_translation.to_translation_hash
          cache_translation(ScopeTranslations.new(scope_translation.locale, hash))
        end
      end

    end
  end
end

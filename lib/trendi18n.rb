
module Trendi18n
  module Backend

    class Trendi18n < I18n::Backend::Simple
      delegate :up_to_date?, :to => Translation # delgate up_to_date? method to Translation model

      def available_locales
        Translation.locales
      end

      def translate(locale, key, options = {})
        raise InvalidLocale.new(locale) if locale.nil?

        #if key is an array then as a result run yourself for all subkey in key
        return key.map { |subkey| translate(locale, subkey, options)} if key.is_a?(Array)

        # read count, scope and default from options
        count, scope, default = options.values_at(:count, :scope, :default)

        options.delete(:default) #delete default from option

        # read values of scope and default options and delete them form options
        values = options.reject {|name, value| [:scope, :default].include?(name)}

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
        super # run standard I18n::Backend::Simple reload! method
        Translation.clear_base_read_at # and clear information about time of last translation's base read
      end

      protected

      def init_translations
        # only set @initialized. Translations will be caching in real-time
        @initialized = true
      end




      def lookup(locale, key, default, scope)
        # cache and return translation. Translation can be find by:
        # - standard I18n::Backend::Simple.lookup method. If its failed, then:
        # - Translation model lookup method
        cache_translation(translation = Translation.lookup(locale, key, default, scope)) unless translation = super(locale, key, scope)
        translation

     end

      private

      def nested
        # assign new instance of I18n::Backend::Simple for @nested if its not exists
        @nested ||= I18n::Backend::Simple.new
      end

      def cache_translation(translation)
        # add translation to stored
        store_translations(translation.locale, translation.to_translation_hash)
      end

    end
  end
end

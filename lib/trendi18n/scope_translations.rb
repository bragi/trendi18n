module Trendi18n

    # Simple class use to caching hash of translations in scope
    class ScopeTranslations

      attr_accessor :locale, :to_translation_hash

      def initialize(locale, to_translation_hash)
        @locale, @to_translation_hash = locale, to_translation_hash
      end
    end
  
end

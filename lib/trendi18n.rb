
module Trendi18n
  module Backedn

    class Model < I18n::Backend::Simple
      delegate :up_to_date, :to => Translation

      def available_locales
        Translation.locales
      end
    end



  end
end

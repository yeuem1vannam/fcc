module Fcc::Error
  CODES = {
    unknown: 500,
  }

  class Base < ::Exception
    def initialize *args
      if args.length == 0
        t_key = self.class.name.underscore.gsub(/\//, ".")
        super I18n.t(t_key)
      else
        super *args
      end
    end
  end

  module API
    module Common
      class Unknown < Fcc::Error::Base
      end
    end
  end
end

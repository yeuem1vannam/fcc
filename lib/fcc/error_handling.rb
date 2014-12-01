module Fcc::ErrorHandling
  def define_handle_exception_methods
    Rack::Utils::SYMBOL_TO_STATUS_CODE.keys.each do |status|
      define_singleton_method("handle_as_#{status}") do |*args|
        rescue_from *args do |e|
          @success = 0
          @error = e
          @status = status
          @status_code = if args[1].try :[], :error_code
                           args[1][:error_code]
                         end
          render "api/v1/common/error"
        end
      end
    end
  end
end

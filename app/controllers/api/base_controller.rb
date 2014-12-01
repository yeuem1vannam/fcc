class Api::BaseController < ApplicationController
  respond_to :json

  extend Fcc::ErrorHandling
  define_handle_exception_methods
  handle_as_internal_server_error Exception,
    error_code: Fcc::Error::CODES[:unknown]
end

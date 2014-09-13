class ApplicationController < ActionController::Base
  protect_from_forgery
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end

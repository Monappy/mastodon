# frozen_string_literal: true

class Auth::ConfirmationsController < Devise::ConfirmationsController
  layout 'auth'
  def new
    raise ActionController::RoutingError.new('Not Found')
  end
end

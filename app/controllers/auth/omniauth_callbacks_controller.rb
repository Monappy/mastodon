class Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def monappy
    user = User.login_with_monappy(request.env['omniauth.auth'])
    remember_me(user)
    sign_in(user)
    redirect_to root_path
  end
end

class MonappyController < ApplicationController
  def callback
    data = request.env["omniauth.auth"]
    sign_in UserMonappy.sign_in(data)
    redirect_to :root
  end
end

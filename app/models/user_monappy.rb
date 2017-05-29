class UserMonappy
  def self.sign_in(data)
    user = User.find_or_create_by(
      email: "#{data.info['mail']}"
    )
    unless user.account.present?
      user.account = Account.new(username: data.info[:nickname])
      user.password  = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
    user.account.avatar_remote_url = data.info[:image]
    user.save!
    user
  end

end


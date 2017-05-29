class UserMonappy
  def self.sign_in(data)
    user = User.find_or_create_by(
        email: "#{data.info['mail'].downcase}"
    )
    p user
    p user.account
    unless user.account.present?
      p "But not presented..."
      user.account = Account.new(username: data.info[:nickname])
      user.password  = Devise.friendly_token[0,20]
      user.account.avatar_remote_url = data.info[:image]
      begin 
        user.save!
      rescue
      end
      user.skip_confirmation!
    end
    user
  end

end


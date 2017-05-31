class UserMonappy
  def self.sign_in(data)
    temp_user = User.find_by(email: data.info[:mail])
    if temp_user.present? and not temp_user.monappy_uid.present?
      temp_user.update_attribute(:monappy_uid , data.info[:id])
    end

    user = User.find_or_create_by(
        monappy_uid: "#{data.info[:id]}"
    )
    unless user.account.present?
      p "But not presented..."
      user.account = Account.new(username: data.info[:nickname])
      user.email = data.info[:mail]
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


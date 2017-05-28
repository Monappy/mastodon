class UserMonappy
  def self.sign_in(data)
    user = User.find_or_create_by(
      email: "#{data['mail']}"
    )
    unless user.account.present?
      user.account = Account.new(username: data[:nickname])
      user.password  = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
    user.account.avatar_remote_url = data[:image]
    user.save!
    user
  end

  def self.pull_all
    User.all.each do |user|
      user.save!
    end
  end
end


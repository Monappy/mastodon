Rails.application.config.middleware.use OmniAuth::Builder do
  provider :monappy, ENV['MONAPPY_KEY'], ENV['MONAPPY_SECRET']
end

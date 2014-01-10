Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '726528350693125', '96ec2c1f6e53d6d1b4607164c190109c'
end
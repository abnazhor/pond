Rails.application.configure do
  MissionControl::Jobs.http_basic_auth_user = Rails.env.development? ? "admin" : Figaro.env.admin_user
  MissionControl::Jobs.http_basic_auth_password = Rails.env.development? ? "admin" : Figaro.env.admin_password
end

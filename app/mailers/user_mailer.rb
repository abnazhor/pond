class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.auth_code.subject
  #
  def auth_code(user, auth_code)
    @auth_code = auth_code

    mail to: user.email_address, subject: "Your sign-in code for PPP"
  end
end

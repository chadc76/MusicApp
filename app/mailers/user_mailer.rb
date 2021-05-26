class UserMailer < ApplicationMailer
  def activation_email(user)
    @user = user
    @url = activate_user_url + "?activation_token=#{user.activation_token}"

    mail(to: user.email, subject: 'Activation for Music App!')
  end
end

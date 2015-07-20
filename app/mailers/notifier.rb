class Notifier < ApplicationMailer
  default from: "noreply@fingertips.com"
  
  def instruction(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end
  
  def reset_password(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end

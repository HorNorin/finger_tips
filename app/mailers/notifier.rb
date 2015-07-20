class Notifier < ApplicationMailer
  default from: "noreply@fingertips.com"
  
  def instruction(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end
end

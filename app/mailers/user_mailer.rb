class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        @login_url = 'www.biblichor.site'
        mail(to: @user.email, subject: 'Welcome to Biblichor')
    end
end

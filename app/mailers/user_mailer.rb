class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        @login_url = 'http://example.com/login'
        mail(to: @user.email, subject: 'Welcome to Biblichor')
    end
end

module MailHelper

  def welcome_email(email, id)
    mail = Mail.new do
      from    'noreply@matcha.com'
      to      email
      subject 'Bienvenue sur Petsder !'
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "<h1>Bienvenue</h1><br/>
        <p>Votre inscription sur Petsder a bien été prise en compte :)</p>"
      end
    end
    mail.deliver
  end

  def password_email(user)
    token = user.password_token
    puts token
    email = user.email
    id = user.id
    mail = Mail.new do
      from    'noreply@matcha.com'
      to      email
      subject 'Modifier mon mot de passe'
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "<h1>Cliquez sur le lien ci-dessous pour réinitialiser votre mot de passe :</h1><br/>
        <a href='http://localhost:4567/new-password?token=#{token}&id=#{id}'>Modifier</a>"
      end
    end
    mail.deliver
  end

end

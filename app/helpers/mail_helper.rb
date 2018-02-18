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

end

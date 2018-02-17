module MailHelper

  def user_email(email, token, id)
    mail = Mail.new do
      from    'noreply@matcha.com'
      to      email
      subject 'Confirmer votre email'
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "<h1>Cliquez sur le lien ci-dessous pour confirmer votre email :</h1><br/>
        <a href='http://localhost:4567/confirm?token=#{token}&id=#{id}'>Confirmer mon email</a>"
      end
    end
    mail.deliver
  end

end

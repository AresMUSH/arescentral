require 'sendgrid-ruby'

class Mailer
  def self.send(to, subject, message)
    include SendGrid

    from = Email.new(email: 'no-reply@aresmush.com')
    subject = subject
    to = Email.new(email: to)
    content = Content.new(type: 'text/plain', value: message)
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: Secrets.mail_api_key)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    
  end
end

#mg_client = Mailgun::Client.new Config.mail_api_key
#message_params = {:from    => 'no-reply@aresmush.com',  
#                  :to      => handle.email,
#                  :subject => 'AresCentral Password Reset',
#                  :text    => message}
#
#mg_client.send_message Config.mail_host, message_params
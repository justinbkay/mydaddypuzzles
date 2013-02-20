ActionMailer::Base.smtp_settings = {
  :port           => 587,
  :address        => smtp.mailgun.org,
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => 'app12119805.mailgun.org',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp

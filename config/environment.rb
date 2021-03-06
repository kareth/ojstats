# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ojstats::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :user_name => APP_CONFIG['mailer']['user_name'],
  :password => APP_CONFIG['mailer']['password'],
  :authentication => 'plain',
  :enable_starttls_auto => true,
}

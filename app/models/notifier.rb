class Notifier < ActionMailer::Base
  default_url_options[:host] = Settings.domain
  
  def registration_email(user)
    subject       "Activate your new #{Settings.site.name} account"
    from          Settings.mailer.from
    recipients    user.email
    sent_on       Time.now
    body          :user => user
  end
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions for #{Settings.site.name}"
    from          Settings.mailer.from
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
# frozen_string_literal: true

ActionMailer::Base.default_options = { from: "PrepSmarter <#{ENV['SMTP_DEFAULT_SENDER']}>" }
ActionMailer::Base.smtp_settings = {
  user_name: ENV['SMTP_USERNAME'], # for eg. sharad@mindnudge.com
  password: ENV['SMTP_PASSWORD'],
  domain: 'prepsmarter.com',
  address: ENV['SMTP_SERVER'],
  port: ENV['SMTP_PORT'],
  authentication: :login,
  enable_starttls_auto: true
}

module ActionMailer
  class DeliveryJob
    queue_as :default
  end
end

class EmailSubjectInterceptor
  def self.delivering_email(mail)
    domain = Mail::Address.new(mail.to.first).domain
    mail.perform_deliveries = domain == 'prepsmarter.com' || domain == 'mailinator.com' || ENV['SMTP_SERVER'] == '127.0.0.1'
    mail.subject = "[#{Rails.env.upcase}] - #{mail.subject}"
  end
end

ActionMailer::Base.register_interceptor(EmailSubjectInterceptor) unless Rails.env.production?

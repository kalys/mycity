# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'admin@example.com'
  layout 'mailer'
end

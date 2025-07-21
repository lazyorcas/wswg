class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV["GMAIL_SENDER_NAME"]} <#{ENV["GMAIL_SENDER_EMAIL"]}>"
  layout "mailer"

  helper_method :i18n_key_prefix, :t

  def t(key, **options)
    super(key, **options.merge(scope: [ mailer_scope, action_name ]))
  end

  # https://apidock.com/rails/v5.2.3/ActionMailer/Base/default_i18n_subject
  def mailer_scope
    @mailer_scope ||= self.class.mailer_name.tr("/", ".")
  end
end

class UserMailerPreview < ActionMailer::Preview
  def weekly_events_notification
    UserMailer.with(user: User.first).weekly_events_notification
  end
end

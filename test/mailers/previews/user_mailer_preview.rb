class UserMailerPreview < ActionMailer::Preview
  def weekly_city_events_notification
    UserMailer.with(user: User.first).weekly_city_events_notification
  end

  def weekly_nearby_events_notification
    UserMailer.with(user: User.first).weekly_nearby_events_notification
  end
end

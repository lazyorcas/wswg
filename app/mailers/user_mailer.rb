class UserMailer < ApplicationMailer
  # User.includes(:city).find_each do |user|
  #   if user.city.present?
  #     UserMailer.with(user: user).weekly_city_events_notification.deliver_later(wait: 1.hour)
  #   else
  #     UserMailer.with(user: user).weekly_nearby_events_notification.deliver_later(wait: 1.hour)
  #   end
  # end

  def weekly_city_events_notification
    load_user
    load_city

    start_date = @city.time_zone.now.beginning_of_week.to_date
    end_date = @city.time_zone.now.end_of_week.to_date

    @events_count = Event
      .joins(:city_source)
      .where(city_sources: { city_id: @city.id })
      .where(start_date: start_date..end_date)
      .count

    return if @events_count.zero?

    @start_date_str = start_date.strftime("%-d %B")
    @end_date_str = end_date.strftime("%-d %B")

    url = all_city_events_url(city_slug: @city.slug)
    @utm_url = Url.build_utm_url(
      url,
      campaign: "retention",
      source: "weekly_events_notification",
      medium: "email",
      content: "simple"
    )

    subject = default_i18n_subject(
      city_name: @city.name,
      start_date: @start_date_str
    )
    mail(to: @user.email, subject: subject)
  end

  def weekly_nearby_events_notification
    load_user

    start_date = Date.today.beginning_of_week
    end_date = Date.today.end_of_week

    @start_date_str = start_date.strftime("%-d %B")
    @end_date_str = end_date.strftime("%-d %B")

    url = all_nearby_events_url
    @utm_url = Url.build_utm_url(
      url,
      campaign: "retention",
      source: "weekly_events_notification",
      medium: "email",
      content: "simple"
    )

    subject = default_i18n_subject(start_date: @start_date_str)
    mail(to: @user.email, subject: subject)
  end

  private

  def load_user
    @user = params[:user]
  end

  def load_city
    @city = @user.city
  end
end

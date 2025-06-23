class UserMailer < ApplicationMailer
  def weekly_events_notification
    @user = params[:user]
    @city = @user.city

    @events_count = Event
      .joins(:city)
      .where(city: { name: @city.name })
      .where("CONCAT(start_date, 'T', start_time) >= ?", "#{@city.time_zone.current_date}T#{@city.time_zone.current_time}")
      .count

    return if @events_count.zero?

    week_start_date = @city.time_zone.now.beginning_of_week.to_date
    week_end_date = @city.time_zone.now.end_of_week.to_date
    @week_start_date_str = week_start_date.strftime("%-d %B")
    @week_end_date_str = week_end_date.strftime("%-d %B")

    url = all_city_events_url(city_slug: @city.slug, event_category_slug: "events")
    @utm_url = Url.build_utm_url(url, campaign: "retention", source: "simple_weekly_events_notification", medium: "email")

    subject = "What's happening in #{@city.name} - Week of #{@week_start_date_str}"

    mail(to: @user.email, subject: subject)
  end
end

module BusinessesHelper
  def businesses_nav_items
    items = [
      {
        label: "Events",
        path: business_events_path
      },
      {
        label: "Bookmarks",
        path: business_bookmarks_path
      }
    ]

    if Current.business.organizer.present?
      items << {
        label: "Your Events",
        path: business_organizer_events_path
      }
    end

    items
  end
end

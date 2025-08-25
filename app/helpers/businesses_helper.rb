module BusinessesHelper
  def businesses_nav_items
    [
      {
        label: "Events",
        path: business_events_path
      },
      {
        label: "Bookmarks",
        path: business_bookmarks_path
      },
      {
        label: "Your Events",
        path: business_organizer_events_path
      }
    ]
  end
end

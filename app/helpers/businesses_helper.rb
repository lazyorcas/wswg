module BusinessesHelper
  def businesses_nav_items
    [
      {
        label: "Events",
        path: business_events_path
      }
      # {
      #   label: "Organizers",
      #   path: business_organizers_path
      # },
      # {
      #   label: "Bookmarks",
      #   path: business_bookmarks_path
      # }
    ]
  end
end

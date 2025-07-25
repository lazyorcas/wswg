module BusinessesHelper
  def business_events_path(*args, **kwargs)
    kwargs = admin? ? { business_id: Current.business.id, **kwargs } : {}
    super(*args, **kwargs)
  end

  def business_organizers_path(*args, **kwargs)
    kwargs = admin? ? { business_id: Current.business.id, **kwargs } : {}
    super(*args, **kwargs)
  end

  def business_bookmarks_path(*args, **kwargs)
    kwargs = admin? ? { business_id: Current.business.id, **kwargs } : {}
    super(*args, **kwargs)
  end

  def businesses_nav_items
    [
      {
        label: "Events",
        path: business_events_path
      },
      {
        label: "Organizers",
        path: business_organizers_path
      },
      {
        label: "Bookmarks",
        path: business_bookmarks_path
      }
    ]
  end

  def businesses_table_headers
    headers = [
      {
        icon: "ph-text-aa",
        label: "Title",
        width: 30
      },
      {
        icon: "ph-megaphone",
        label: "Organizer",
        width: 15
      },
      {
        filter_id: :dow,
        icon: "ph-calendar",
        label: "Date",
        width: 15
      },
      {
        filter_id: :tod,
        icon: "ph-clock",
        label: "Time",
        width: 10
      },
      {
        icon: "ph-map-pin",
        label: "Venue",
        width: 20
      },
      {
        filter_id: :source,
        icon: "ph-globe",
        label: "Source",
        width: 10
      }
    ]

    if headers.map { |header| header[:width] }.sum != 100
      raise "Headers width must sum to 100"
    end

    headers
  end
end

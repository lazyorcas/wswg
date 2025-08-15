module Businesses::Organizers::BookmarksHelper
  def business_organizers_bookmarks_table_headers
    headers = [
      {
        icon: "ph-megaphone",
        label: "Organizer",
        width: 100
      }
    ]

    if (sum = headers.map { |header| header[:width] }.sum) != 100
      raise "Headers width (#{sum}) must sum to 100"
    end

    headers
  end
end

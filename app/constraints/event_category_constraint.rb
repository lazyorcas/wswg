class EventCategoryConstraint
  ALLOWED_SLUGS = EventCategory::SLUGS - [ "events" ]
  REGEX = /#{ALLOWED_SLUGS.join('|')}/
end

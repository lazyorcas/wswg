class TimePeriodConstraint
  ALLOWED_SLUGS = TimePeriod::SLUGS - [ "all" ]
  REGEX = /#{ALLOWED_SLUGS.join('|')}/
end

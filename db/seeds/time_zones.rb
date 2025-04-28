[ "Asia/Singapore", "Europe/Berlin" ].each do |time_zone|
  TimeZone.find_or_create_by(name: time_zone)
end

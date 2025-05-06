user = User.find_or_initialize_by(email: ENV["ROOT_USER_EMAIL"])
if user.new_record?
  city = City.unscoped.find_by(name: ENV["ROOT_USER_CITY_NAME"])

  user.assign_attributes(city_id: city.id, admin: true)
  user.save!
end

user = User.find_or_initialize_by(email: ENV["ROOT_USER_EMAIL"])
if user.new_record?
  user.assign_attributes(city_id: 1, admin: true)
  user.save!
end

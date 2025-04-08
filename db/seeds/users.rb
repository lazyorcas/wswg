user = User.find_or_initialize_by(email: ENV["ROOT_USER_EMAIL"])
if user.new_record?
  user.assign_attributes(
    name: "Oscar",
    city: City.find_by(name: "Singapore"),
    admin: true
  )
  user.save!
end

user = User.find_or_initialize_by(email: ENV["ROOT_USER_EMAIL"])
if user.new_record?
  user.name = "Oscar"
  user.admin = true
  user.save!
end

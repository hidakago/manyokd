# 1.times do |n|
#   name = Faker::Games::Pokemon.name
#   email = Faker::Internet.email
#   password = "password"
#   admin_allowed = false
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password,
#                admin_allowed: false,
#                )
# end
10.times do |n|
  name = "label_name#{n}"
  Label.create!(name: name,
               )
end

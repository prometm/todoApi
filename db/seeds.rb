# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Project.delete_all
User.delete_all

user1 = User.create(
  email: 'a@aa.aaa',
  password: '123456pass',
  password_confirmation: '123456pass'
  )

user2 = User.create(
  email: 'b@bb.bbb',
  password: '123456pass',
  password_confirmation: '123456pass'
  )

2.times do |i|
  Project.create(
    name: "Project #{i}",
    user: user1
    )
end

Project.create(
    name: "Project by user2",
    user: user2
    )

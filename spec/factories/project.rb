FactoryBot.define do
  factory :project do
    name { FFaker::Lorem.sentence }
    user
  end
end
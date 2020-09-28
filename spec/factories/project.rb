# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { FFaker::Lorem.sentence }
    user
  end
end

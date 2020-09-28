# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.sentence }
    position { rand(1..10) }
    done { false }
    deadline { nil }

    project
  end
end

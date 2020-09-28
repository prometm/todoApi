# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { '123456pass' }
    password_confirmation { '123456pass' }
  end
end

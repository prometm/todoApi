# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(:position) }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

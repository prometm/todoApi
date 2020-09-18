class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :user
  has_many :tasks

  link(:self) { api_v1_project_url(object) }
end

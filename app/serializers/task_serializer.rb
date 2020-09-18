class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :done, :deadline

  belongs_to :project

  link(:self) { api_v1_task_url(object) }
end

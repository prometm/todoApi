# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource :project
      load_and_authorize_resource :task, through: :project, shallow: true

      resource_description do
        short "Task's endpoints"
        error 401, 'Unautorized'
        error 422, 'Unprocessable Entity'
        formats ['json']
      end

      def_param_group :task do
        param :data, Hash, required: true do
          param :attributes, Hash, required: true do
            param :name, String, required: true
            param :position, Integer
            param :done, String
            param :deadline, String
          end
        end
      end

      api :GET, '/api/v1/projects/:id/tasks', "Get all project's tasks"
      def index
        render json: @tasks, status: :ok
      end

      api :GET, '/api/v1/projects/:project_id/tasks/:id', 'Show the task'
      def show
        render json: @task, status: :ok
      end

      api :POST, '/api/v1/projects/:project_id/tasks', 'Create new task'
      param_group :task
      def create
        if @task.save
          render json: @task, status: :created
        else
          render json: task_errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/api/v1/projects/:project_id/tasks/:id', 'Updates task with new name'
      param_group :task
      def update
        if @task.update(task_params)
          render json: @task, status: :created
        else
          render json: task_errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/api/v1/projects/:project_id/tasks/:id', 'Deletes task'
      def destroy
        @task.destroy
      end

      api :PATCH, '/api/v1/projects/:project_id/tasks/:id/position', 'Change position of task'
      param :data, Hash, required: true do
        param :attributes, Hash, required: true do
          param :position, Integer, required: true
        end
      end
      def position
        @task.insert_at(position_param[:position].to_i)
        if @task.errors.empty?
          render json: @task, status: :created
        else
          render json: task_errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/api/v1/projects/:project_id/tasks/:id/complete', "Set task's done to true or false"
      def complete
        @task.update(done: !@task.done)
        if @task.errors.empty?
          render json: @task, status: :created
        else
          render json: task_errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/api/v1/projects/:project_id/tasks/:id/deadline', "Set task's deadline"
      param :data, Hash, required: true do
        param :attributes, Hash, required: true do
          param :deadline, String, required: false
        end
      end
      def deadline
        if @task.update(deadline_param)
          render json: @task, status: :created
        else
          render json: task_errors, status: :unprocessable_entity
        end
      end

      private

      def task_errors
        { error: @task.errors, serializer: ActiveModel::Serializer::ErrorSerializer }
      end

      def task_params
        request_params.permit(:name, :position, :done, :deadline)
      end

      def position_param
        request_params.permit(:position)
      end

      def deadline_param
        request_params.permit(:deadline)
      end
    end
  end
end

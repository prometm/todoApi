# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource

      resource_description do
        short "Project's endpoints"
        error 401, 'Unautorized'
        error 422, 'Unprocessable Entity'
        formats ['json']
      end

      def_param_group :project do
        param :data, Hash, required: true do
          param :attributes, Hash, required: true do
            param :name, String, required: true
          end
        end
      end

      api :GET, '/api/v1/projects', "Get all user's projects"
      def index
        @projects.order!(:id)
        render json: @projects, status: (@projects ? :ok : :unauthorized)
      end

      api :GET, '/api/v1/projects/:id', "Get specific user's project"
      def show
        render json: @project, status: :ok
      end

      api :POST, '/api/v1/projects', "Create new user's project"
      param_group :project
      def create
        if @project.save
          render json: @project, status: :created
        else
          render json: project_errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/api/v1/projects/:id', 'Updates project with new name'
      param_group :project
      def update
        render json: rezult = @project.update(project_params), status: (rezult ? :created : :unprocessable_entity)
      end

      api :DELETE, '/api/v1/projects/:id', 'Deletes project'
      def destroy
        @project.destroy
      end

      private

      def project_errors
        { error: @project.errors, serializer: ActiveModel::Serializer::ErrorSerializer }
      end

      def project_params
        request_params.permit(:name)
      end
    end
  end
end

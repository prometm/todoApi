RSpec.describe 'Tasks endpoints', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, user: user) }
  let(:task) { FactoryBot.create(:task, project: project) }
  let(:user_token) { user.create_new_auth_token }
  let(:invalid_params) { request_params(name: '') }
  let(:valid_position) { request_params(position: 7) }

  def request_params(inner_params)
    { data: { attributes: inner_params } }
  end

  describe 'GET /api/v1/projects/:id/tasks' do
    context 'user is logged in', :show_in_doc do
      it 'returns list of tasks, status #ok' do
        3.times { FactoryBot.create(:task, project: project) }
        get api_v1_project_tasks_path(project), headers: user_token
        expect(response).to have_http_status(:ok)
      end

      # it 'returns list of tasks, validates with schema' do
      #   3.times { create(:task, project: project) }
      #   get api_v1_project_tasks_path(project), headers: user_token
      #   expect(response).to match_response_schema('tasks/index')
      # end
    end

    context 'user is not logged in' do
      it 'restricts access' do
        get api_v1_project_tasks_path(project)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    it 'user is logged in' do
      get api_v1_project_task_path(project, task), headers: user_token
      expect(response).to have_http_status(:ok)
    end

    # it 'validate with schema' do
    #   get api_v1_project_task_path(project, task), headers: user_token
    #   expect(response).to match_response_schema('tasks/task')
    # end

    it 'user is not logged in' do
      get api_v1_project_task_path(project, task)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks' do
    let(:valid_params) { request_params(name: "Task's name") }

    context 'user is logged in' do
      context 'valid params' do
        it 'create task, status created' do          
          post api_v1_project_tasks_path(project), headers: user_token, params: valid_params
          expect(response).to have_http_status(:created)
        end

        # it 'validate with schema' do
        #   post api_v1_project_tasks_path(project), headers: user_token, params: valid_params
        #   expect(response).to match_response_schema('tasks/task')
        # end

        it 'create new task' do
          expect { post api_v1_project_tasks_path(project), headers: user_token, params: valid_params }.to(
            change { Task.count }.from(0).to(1)
          )
        end
      end

      context 'invalid params' do
        it 'returns status unprocessable entity' do
          post api_v1_project_tasks_path(project), headers: user_token, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'user is not logged in' do
      it 'returns status unauthorized' do
        post api_v1_project_tasks_path(project), params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'PATCH /api/v1/tasks/:id' do
    let(:new_valid_params) { request_params(name: "Another task's name") }
    context 'user is logged in' do
      context 'valid_params' do
        it "updates task's name from first_name to new_name" do
          first_name = task.name
          new_name = new_valid_params[:data][:attributes][:name]
          expect { patch api_v1_project_task_path(project, task), headers: user_token, params: new_valid_params }.to(
            change { project.tasks.first.name }.from(first_name).to(new_name)
          )
        end

        # it 'validate with schema' do
        #   patch api_v1_project_task_path(project, task), headers: user_token, params: new_valid_params
        #   expect(response).to match_response_schema('tasks/task')
        # end
      end

      context 'invalid_params' do
        it 'returns status unprocessable entity' do
          patch api_v1_project_task_path(project, task), headers: user_token, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'user is not logged in' do
      it 'returns status unauthorized' do
        patch api_v1_project_task_path(project, task), params: new_valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'DELETE /api/v1/tasks/:id' do
    context 'user is logged in' do
      it 'delete task from db' do
        task
        expect { delete api_v1_project_task_path(project, task), headers: user_token }.to(
          change { Task.count }.from(1).to(0)
        )
      end

      it 'returns status no_content' do
        delete api_v1_project_task_path(project, task), headers: user_token
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  context 'PATCH /api/v1/task/:id/position' do
    context 'user is logged in' do
      it 'return status #create' do
        patch position_api_v1_project_task_path(project, task), headers: user_token, params: valid_position
        expect(response).to have_http_status(:created)
      end

      # it 'validate with schema' do
      #   patch position_api_v1_project_task_path(project, task), headers: user_token, params: valid_position
      #   expect(response).to match_response_schema('tasks/task')
      # end

      it "change task's position" do
        task
        position = task.position
        expect { patch position_api_v1_project_task_path(project, task), headers: user_token, params: valid_position }.to(
          change { project.tasks.first.position }.from(position).to(7)
        )
      end
    end

    context 'user is not logged in' do
      it 'returns status unauthorized' do
        patch position_api_v1_project_task_path(project, task), params: valid_position
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'PATCH /api/v1/tasks/:id/complete' do
    context 'user is logged in' do
      it 'return status #create' do
        patch complete_api_v1_project_task_path(project, task), headers: user_token
        expect(response).to have_http_status(:created)
      end

      # it 'validate with schema' do
      #   patch complete_api_v1_project_task_path(project, task), headers: user_token
      #   expect(response).to match_response_schema('tasks/task')
      # end

      it "change #done from false to true" do
        task
        expect { patch complete_api_v1_project_task_path(project, task), headers: user_token }.to(
          change { project.tasks.first.done }.from(false).to(true)
        )
      end

      it "change #done true false to false" do
        task
        # patch complete_api_v1_project_task_path(project, task)
        expect { patch complete_api_v1_project_task_path(project, task), headers: user_token }.to(
          change { project.tasks.first.done }.from(false).to(true)
        )
      end
    end

    context 'user is not logged in' do
      it 'returns status unauthorized' do
        patch complete_api_v1_project_task_path(project, task)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
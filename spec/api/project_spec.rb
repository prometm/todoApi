# frozen_string_literal: true

RSpec.describe 'Projects endpoints', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, user: user) }
  let(:user_token) { user.create_new_auth_token }
  let(:invalid_params) { request_params(name: '') }

  def request_params(inner_params)
    { data: { attributes: inner_params } }
  end

  describe 'GET /api/v1/projects' do
    context 'user is logged in', :show_in_doc do
      it 'returns status ok' do
        get api_v1_projects_path, headers: user_token
        expect(response).to have_http_status(:ok)
      end
    end

    context 'user is not logged in' do
      it 'restricts access' do
        get api_v1_projects_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/projects/:id' do
    it 'user is logged in' do
      get api_v1_project_path(project), headers: user_token
      expect(response).to have_http_status(:ok)
    end

    it 'user is not logged in' do
      get api_v1_project_path(project)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/projects' do
    let(:valid_params) { request_params(name: "Project's name") }

    context 'user is logged in' do
      context 'valid params' do
        it 'create project, status created' do
          post api_v1_projects_path, headers: user_token, params: valid_params
          expect(response).to have_http_status(:created)
        end

        it 'create new project' do
          expect { post api_v1_projects_path, headers: user_token, params: valid_params }.to(
            change { Project.count }.from(0).to(1)
          )
        end
      end

      context 'invalid params' do
        it 'returns status unprocessable entity' do
          post api_v1_projects_path, headers: user_token, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'user is not logged in' do
      it 'returns status unauthorized' do
        post api_v1_projects_path, params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'PATCH /api/v1/projects/:id' do
    let(:new_valid_params) { request_params(name: 'Another name') }
    context 'user is logged in' do
      context 'valid_params' do
        it "updates project's name from first_name to new_name" do
          first_name = project.name
          new_name = new_valid_params[:data][:attributes][:name]
          expect { patch api_v1_project_path(project), headers: user_token, params: new_valid_params }.to(
            change { user.projects.first.name }.from(first_name).to(new_name)
          )
        end
      end

      context 'invalid_params' do
        it 'returns status unprocessable entity' do
          patch api_v1_project_path(project), headers: user_token, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'user is not logged in' do
      it 'returns status unauthorized' do
        patch api_v1_project_path(project), params: new_valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'DELETE /api/v1/projects/:id' do
    context 'user is logged in' do
      it 'delete project from db' do
        project
        expect { delete api_v1_project_path(project), headers: user_token }.to(
          change { Project.count }.from(1).to(0)
        )
      end

      it 'returns status no_content' do
        delete api_v1_project_path(project), headers: user_token
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end

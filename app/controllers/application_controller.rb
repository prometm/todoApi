class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  private

  def request_params
    params.require(:data).require(:attributes)
  end
end

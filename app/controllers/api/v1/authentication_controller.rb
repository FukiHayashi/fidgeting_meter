class Api::V1::AuthenticationController < Api::V1::BaseController
  skip_before_action :authenticate, only: %i[create]

  def create
    @user = login(params[:email], params[:password])
    raise ActiveRecord::RecordNotFound if @user.blank?

    # generate_api_key
    api_key = @user.activate_api_key!
    response.headers['AccessToken'] = api_key.access_token

    # return json with user infomation
    json_string = UserSerializer.new(@user).serialized_json
    render json: json_string
  end

  private

  def form_authenticity_token; end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

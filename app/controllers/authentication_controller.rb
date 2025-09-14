class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode({ user_id: user.id })
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def logout
    header = request.headers['Authorization']
    token = header&.split(' ')&.last
    return head :no_content unless token

    claims = JsonWebToken.decode(token)
    JwtDenylist.create!(jti: claims.jti, exp: Time.at(claims.exp))
    render json: { message: 'Logged out' }, status: :ok
  rescue StandardError
    head :no_content
  end
end

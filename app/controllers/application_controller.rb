class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header&.split(' ')&.last
    return render json: { error: 'Missing token' }, status: :unauthorized unless token

    claims = JsonWebToken.decode(token)
    if JwtDenylist.exists?(jti: claims.jti) || Time.at(claims.exp) < Time.current
      return render json: { error: 'Token expired or revoked' }, status: :unauthorized
    end

    @current_user = User.find(claims.user_id)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :unauthorized
  rescue StandardError
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
end

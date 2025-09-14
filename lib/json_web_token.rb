# lib/json_web_token.rb
require 'securerandom'
require 'ostruct'
require 'jwt'

class JsonWebToken
  SECRET_KEY = Rails.application.credentials.jwt_secret || ENV['JWT_SECRET'] || 'dev_secret_change_me'

  # Δέχεται είτε positional Hash (encode({ user_id: 1 })) είτε keywords (encode(user_id: 1))
  def self.encode(payload = nil, exp: 24.hours.from_now, **kw)
    data = payload || kw
    raise ArgumentError, 'payload required' if data.nil? || data.empty?

    data = data.to_h
    data[:exp] = exp.to_i
    data[:jti] = SecureRandom.uuid
    JWT.encode(data, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    body, = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
    OpenStruct.new(body)
  rescue JWT::DecodeError => e
    raise StandardError, e.message
  end
end

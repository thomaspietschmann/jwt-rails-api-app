class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    exp = Time.now.to_i + 30
    p exp
    exp_payload = {
      data: payload,
      exp: exp
    }
    JWT.encode(exp_payload, ENV['SECRET'])
    # JWT.encode(payload, ENV['SECRET'])
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, ENV['SECRET'], true, algorithm: 'HS256')
      rescue JWT::DecodeError
        p 'Token decoding error'
        nil
      end
    end
  end

  def logged_in_user
    p 'decoding'
    if decoded_token
      user_id = decoded_token[0]['data']['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user # forces return value to be a boolean
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end

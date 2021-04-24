class Api::V1::UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  # REGISTER
  def create
    if params[:password] != params[:password_confirmation]
      return render json: { error: "Password and confirmation don't match" }
    end

    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: @user.errors.messages }
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: 'Invalid username or password' }
    end
  end

  def auto_login
    render json: { user: {
      username: @user.username,
      age: @user.age
    } }
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :age)
  end
end

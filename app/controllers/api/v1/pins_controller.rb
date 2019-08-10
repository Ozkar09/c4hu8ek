class Api::V1::PinsController < ApplicationController

  def index

    if autenticate?
      render json: Pin.all.order('created_at DESC')
    else
      head 401
    end

  end

  def create

    if autenticate?
      pin = Pin.new(pin_params)
      if pin.save
        render json: pin, status: 201
      else
        render json: { errors: pin.errors }, status: 422
      end
    else
      head 401
    end

  end

  def autenticate?

    user = User.find_by(email: user_email_from_headers)
    token = auth_token_from_headers

    autenticate = false

    if user != nil
      if token == user.api_token
        autenticate = true
      end
    end

  end

  def user_email_from_headers
    request.env["HTTP_X_USER_EMAIL"]
  end

  def auth_token_from_headers
    request.env["HTTP_X_AUTH_TOKEN"]
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end

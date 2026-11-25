class Api::UsersController < ApplicationController

  before_action :authenticate_user!

  def me
    render json: current_user.go_json
  end

  def resend_confirmation
    current_user.send_confirmation_instructions unless current_user.confirmed?
    head :no_content
  end

end

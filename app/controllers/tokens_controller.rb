class TokensController < ApplicationController
  before_action :authenticate_user!, except: [:resolve]

  def index
    render json: current_user.tokens
  end

  def show
    render json: current_user.tokens.find(params[:id])
  end

  def update
    token = current_user.tokens.find params[:id]

    params[:token][:translations].each_with_index do |translation_params, index|
      translation = token.translations.find_or_initialize_by priority: index
      translation.update_attributes! translation_params.to_hash.merge(priority: index)
    end
  end

  def resolve
    token = Token.find params[:id]
    target = token.first_active_translation request
    fail 'no active target' if target.nil?

    redirect_to "http://#{ target }"
  end

  private

  def token_params
    params.require(:token).permit.tap do |white_listed|
      white_listed[:translations] = params[:token][:translations]
    end
  end
end

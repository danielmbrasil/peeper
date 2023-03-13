# frozen_string_literal: true

# StatusesController
class StatusesController < ApplicationController
  before_action :find_status, only: %i[show edit update destroy]

  def index
    @statuses = Status.all.includes(:user)
  end

  def show
    render :show, status: :ok
  end

  def new
    @status = Status.new(parent_id: params[:parent_id])
    initialize_media
  end

  def create
    @status = Status.new(status_params)
    if @status.save
      redirect_to @status
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    initialize_media
  end

  def update
    if @status.update(status_params)
      redirect_to @status
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @status.destroy
    redirect_to root_path
  end

  private

  def find_status
    @status = Status.find_by_id(params[:id])

    render file: "#{Rails.root}/public/404.html", status: :not_found unless @status.present?
  end

  def status_params
    params.require(:status).permit(
      :id,
      :body,
      :user_id,
      :parent_id,
      media_attributes: %i[id medium_type url _destroy]
    )
  end

  def initialize_media
    number_of_media_to_be_built = Status::MEDIA_LIMIT - @status.media.size
    number_of_media_to_be_built.times { @status.media.build }
  end
end

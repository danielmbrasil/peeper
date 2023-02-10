# frozen_string_literal: true

# StatusesController
class StatusesController < ApplicationController
  before_action :find_status, only: %i[show edit update]

  def index
    @statuses = Status.all
  end

  def show
    render :show, status: :ok
  end

  def new
    @status = Status.new(status_id: params[:status_id])
    Status::MEDIA_LIMIT.times { @status.media.build }
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
    number_of_media_left = Status::MEDIA_LIMIT - @status.media.size
    number_of_media_left.times { @status.media.build }
  end

  def update
    @status.update(status_params)
    if @status.save
      redirect_to @status
    else
      render :edit, status: :unprocessable_entity
    end
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
      :status_id,
      media_attributes: %i[id medium_type url _destroy]
    )
  end
end

# frozen_string_literal: true

# StatusesController
class StatusesController < ApplicationController
  before_action :find_status, only: :show

  def index
    @statuses = Status.all
  end

  def show
    if @status.present?
      render :show, status: :ok
    else
      render nothing: true, status: :not_found
    end
  end

  private

  def find_status
    @status = Status.find_by_id(params[:id])
  end
end

# frozen_string_literal: true

# StatusesController
class StatusesController < ApplicationController
  def index
    @statuses = Status.all
  end
end

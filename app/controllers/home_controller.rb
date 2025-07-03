# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  layout :determine_layout

  def index
    if user_signed_in?
      render "home/index"
    else
      render "home/landing"
    end
  end

  private

  def determine_layout
    user_signed_in? ? "application" : "landing"
  end
end

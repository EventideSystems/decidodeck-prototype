# frozen_string_literal: true

class HomeController < ApplicationController
  include FlashNotifications
  
  skip_before_action :authenticate_user!

  layout :determine_layout

  def index
    if user_signed_in?
      check_for_new_user_welcome
      render "home/index"
    else
      render "home/landing"
    end
  end

  private

  def check_for_new_user_welcome
    # Show welcome message for users who just signed up
    # We can detect this by checking if they have a flash notice about workspace setup
    if flash[:notice]&.include?("Welcome to Decidodeck")
      # Convert to a success notification with browser notification support
      success_notification("🎉 #{flash[:notice]}", browser_notification: true)
      flash[:notice] = nil # Clear the original flash message
    end
  end

  def determine_layout
    user_signed_in? ? "application" : "landing"
  end
end

class NotificationTestController < ApplicationController
  def index
    # This controller demonstrates different notification types
  end

  def create
    notification_type = params[:type] || 'info'
    
    case notification_type
    when 'success'
      success_notification("✅ Operation completed successfully!")
    when 'error'
      error_notification("❌ Something went wrong! Please try again.")
    when 'warning'
      warning_notification("⚠️ Please check your input and try again.")
    when 'info'
      info_notification("ℹ️ Here's some helpful information.")
    end

    respond_to do |format|
      format.html { redirect_to notification_test_index_path }
      format.turbo_stream # Will use the notification rendering
    end
  end
end

module FlashNotifications
  extend ActiveSupport::Concern

  private

  def add_flash_notification(type, message, duration: nil)
    # Set default duration based on type if not specified
    duration ||= case type.to_s
    when "error", "alert"
      8000
    when "warning"
      6000
    else
      5000
    end

    if request.format.turbo_stream?
      # For Turbo Stream requests, render a notification directly
      render turbo_stream: turbo_stream.append(
        "flash-notifications",
        render_to_string(
          partial: "shared/flash_notification",
          locals: {
            type: type,
            message: message,
            duration: duration
          }
        )
      )
    else
      # For regular requests, use standard flash
      flash[type] = message
    end
  end

  def success_notification(message, duration: 5000)
    add_flash_notification(:success, message, duration: duration)
  end

  def error_notification(message, duration: 8000)
    add_flash_notification(:error, message, duration: duration)
  end

  def warning_notification(message, duration: 6000)
    add_flash_notification(:warning, message, duration: duration)
  end

  def info_notification(message, duration: 5000)
    add_flash_notification(:info, message, duration: duration)
  end
end

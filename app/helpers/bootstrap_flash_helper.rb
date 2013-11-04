module BootstrapFlashHelper
  ALERT_TYPES = [:error, :info, :success, :warning, :validation]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)
      case type
      when :validation
        type = :error
        message.map(&:full_messages).flatten.each do |msg|
          next if msg.include? "translation missing"
          text = content_tag_for_error msg, type
          flash_messages << text if msg
        end
      when :success, :error
        Array(message).each do |msg|
          case msg
          when Symbol
            msg = t("#{params[:controller]}/#{params[:action]}/#{msg}".gsub("/", "."))
            next if msg.include? "translation missing"
          when Array
            msg = t("#{params[:controller]}/#{params[:action]}/#{msg[0]}".gsub("/", "."), msg[1])
            next if msg.include? "translation missing"
          end
          text = content_tag_for_error msg, type
          flash_messages << text if msg
        end
      end
    end
    flash_messages.join("\n").html_safe
  end

  private
  def content_tag_for_error msg, type
    content_tag(:div,
      content_tag(:button, raw("&times;"),
        class: "close", "data-dismiss" => "alert") +
        msg.html_safe.gsub(/</, "&lt;")
        .gsub(/>/, "&gt;"), class: "alert fade in alert-#{type}")
  end
end

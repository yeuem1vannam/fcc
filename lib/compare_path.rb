module ComparePath
  def compare_path path1, path2
    hash1 = recognize_path path1
    hash2 = recognize_path path2
    return false unless hash1.present? && hash2.present?
    hash1[:controller] == hash2[:controller]
  end

  def recognize_path path = nil
    begin
      hash = Rails.application.routes.recognize_path path.to_s
    rescue ActionController::RoutingError
      return nil
    end
  end
end

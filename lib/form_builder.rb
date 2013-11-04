class ActionView::Helpers::FormBuilder
  def full_error_messages_for field
    return [] unless (msgs = self.object.errors[field]).present?
    subject = options[:subject] || self.object.class.human_attribute_name(field)
    msgs.map {|msg| "#{subject}#{msg}"}
  end
end

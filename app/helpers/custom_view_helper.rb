module CustomViewHelper
  include ComparePath
  def requirement_label model, field
    is_required = model.class.validators_on(field).map(&:class)
      .any? do |klass|
        [ActiveModel::Validations::PresenceValidator,
         ActiveModel::Validations::InclusionValidator].include? klass
      end
    prefix = is_required ? "" : "not_"
    type, text = %w(type text).map do |item|
      t "viewhelper.requirement.#{item}.#{prefix}required"
    end
    render partial: "shared/components/label", locals: {type: type, text: text}
  end
end

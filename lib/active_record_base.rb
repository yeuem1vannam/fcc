class ActiveRecord::Base
  class << self
    def h label
      self.human_attribute_name label
    end
  end
end

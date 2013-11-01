class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem

  attr_accessor :content
end

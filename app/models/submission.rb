class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem

  attr_accessor :attached_file

  validates :language, presence: true
  validates :problem_id, presence: true
  validates :user_id, presence: true
  validate :check_opening_contest

  default_scope ->{order 'created_at DESC'}
  scope :of_problem, ->problem_id{where problem_id: problem_id}

  private
  def check_opening_contest
    unless problem.try(:contest).try(:opening?)
      errors.add(:contest, 'Contest ended')
    end
  end
end

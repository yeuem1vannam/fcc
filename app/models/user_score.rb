class UserScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest

  scope :in_contest, ->contest_id{where(contest_id: contest_id) if contest_id}
  scope :of_user, ->user_id{where user_id: user_id}
  default_scope ->{order 'point DESC'}

  validates :user_id, presence: true, numericality: true, uniqueness: {scope: :contest_id}
  validates :contest_id, presence: true, numericality: true

  def add_point received_point
    update point: point + received_point
  end
end

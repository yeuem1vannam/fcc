class Contest < ActiveRecord::Base
  has_many :problems, dependent: :destroy
  has_many :submissions, through: :problems

  default_scope ->{order 'created_at DESC'}

  def opening?
    end_at >= Time.now
  end
end

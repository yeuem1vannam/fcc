class Contest < ActiveRecord::Base
  has_many :problems, dependent: :destroy
  has_many :submissions, through: :problems
  has_many :user_scores, dependent: :destroy

  default_scope ->{order 'created_at DESC'}

  class << self
    def current_contest
      where('start_at < ? AND end_at > ?', Time.now, Time.now).first
    end
  end

  def opening?
    end_at >= Time.now && start_at < Time.now
  end

  def ended?
    end_at < Time.now
  end

  def started?
    start_at < Time.now
  end

  def submitable?
    opening? || (started? && Settings.submit_after_ended)
  end

  def result_announced?
    result_announced_at < Time.now
  end

  def show_point_on_view?
    Settings.show_score_during_contest ? true : !opening?
  end
end

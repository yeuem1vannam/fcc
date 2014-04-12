class UserScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest

  scope :in_contest, ->contest_id{where(contest_id: contest_id) if contest_id}
  scope :of_user, ->user_id{where user_id: user_id}
  default_scope ->{order 'point DESC'}

  validates :user_id, presence: true, numericality: true, uniqueness: {scope: :contest_id}
  validates :contest_id, presence: true, numericality: true

  def add_point! received_point
    update point: point + received_point
    x = UserScore.build_json_table
    y = UserScore.local_user_scores self.contest_id
    WebsocketRails[:submissions].trigger "update", x
    WebsocketRails[:submissions].trigger "show", y
  end

  class << self
    def total_scores
      select('user_id').group('user_id').sum('point')
        .sort_by{|user_id,total_score| total_score}.reverse
    end
    def build_json_table
      result = []
      total_scores.each do |usc|
        x = {}
        x[:id] = usc[0]
        x[:point] = usc[1]
        x[:email] = User.find(usc[0]).email
        x[:percent] = usc[1] * 100.0 / total_scores[0][1]
        result << x
      end
      result
    end

    def local_user_scores contest_id
      contest = Contest.find(contest_id)
      user_scores = UserScore.in_contest(contest)
      result = []
      user_scores.each do |u|
        x = {}
        x[:scores] = {}
        x[:id] = u.user.id
        x[:email] = u.user.email
        contest.problems.desc_rank.each do |p|
          x[:scores]["p#{p.id}"] = u.user.submissions.of_problem(p)
            .maximum(:received_point)
        end
        x[:total_score] = u.point
        result << x
      end
      result
    end
  end
end

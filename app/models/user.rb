class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :submissions, dependent: :destroy
  has_many :user_scores, dependent: :destroy

  def solved? problem
    !submissions.of_problem(problem).accepted.blank?
  end

  def is_reviewer?
    email.in? Settings.reviewer_emails
  end
end

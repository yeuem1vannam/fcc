class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.references :user, index: true
      t.references :contest, index: true
      t.integer :point, default: 0
    end
  end
end

class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.string :description
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :result_announced_at

      t.timestamps
    end
  end
end

class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.references :contest, index: true
      t.string :name
      t.integer :rank
      t.text :content
      t.integer :limited_time
      t.integer :limited_memory
      t.integer :limited_source_size
      t.integer :starting_point
      t.integer :wrong_answer_decreased_point
      t.integer :slowly_decreased_interval

      t.timestamps
    end
  end
end

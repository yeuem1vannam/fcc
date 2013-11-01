class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :problem, index: true
      t.references :user, index: true
      t.string :state
      t.string :result_status
      t.integer :last_passed_test_case
      t.text :output

      t.timestamps
    end
  end
end

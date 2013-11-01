class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.references :problem, index: true
      t.string :input
      t.string :output

      t.timestamps
    end
  end
end

class AddFailedTestCaseOutputToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :failed_test_case_result, :string
  end
end

class AddMultilanguageNameAndContentToProblems < ActiveRecord::Migration
  def change
    rename_column :problems, :name, :name_vi
    rename_column :problems, :content, :content_vi
    add_column :problems, :name_en, :text
    add_column :problems, :content_en, :text

    add_column :users, :locale, :integer, default: 0
  end
end

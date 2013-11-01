require "csv"

def create_master model_class, &block
  return unless block_given?

  csv = "#{Rails.root}/db/master/#{model_class.name.split('::').last.underscore}.csv"
  model_class.destroy_all
  model_class.create! CSV.open(csv).map(&block)
end

namespace :master do
  desc "import master"
  task import: :environment do
    # Sample
    # Article.destroy_all
    # puts "Create Article"
    # create_master Article do |article|
    #   {id: article[0], type: article[1], title: article[2], short_description: article[3], content: article[4]}
    # end
  end
end

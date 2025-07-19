class AddWeightedKeywordsToInterestSets < ActiveRecord::Migration[8.0]
  def change
    add_column :interest_sets, :weighted_keywords, :text, array: true, default: []
    remove_column :interest_sets, :keywords
  end
end

# User.where.associated(:seens).find_each do |user|
#   user.interest_set.update!(weighted_keywords: user.build_weighted_keywords)
# end

# Visitor.where.associated(:seens).find_each do |visitor|
#   visitor.interest_set.update!(weighted_keywords: visitor.build_weighted_keywords)
# end

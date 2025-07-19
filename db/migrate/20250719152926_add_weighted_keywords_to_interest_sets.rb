class AddWeightedKeywordsToInterestSets < ActiveRecord::Migration[8.0]
  def change
    add_column :interest_sets, :weighted_keywords, :text, array: true, default: []
    remove_column :interest_sets, :keywords
  end
end

# User.where.associated(:seens).find_each do |user|
#   weighted_keywords = user.build_weighted_keywords

#   if user.interest_set.present?
#     user.interest_set.update!(weighted_keywords: weighted_keywords)
#   else
#     InterestSet.create!(interestable: user, weighted_keywords: weighted_keywords)
#   end
# end

# Visitor.where.associated(:seens).find_each do |visitor|
#   weighted_keywords = visitor.build_weighted_keywords

#   if visitor.interest_set.present?
#     visitor.interest_set.update!(weighted_keywords: weighted_keywords)
#   else
#     InterestSet.create!(interestable: visitor, weighted_keywords: weighted_keywords)
#   end
# end

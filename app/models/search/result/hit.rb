class Search::Result::Hit
  include StoreModel::Model

  attribute :id, :integer
  attribute :score, :float
end

# https://github.com/ankane/searchkick?tab=readme-ov-file#results

class Search::Result
  include StoreModel::Model

  attribute :ids, array: true, default: []
  attribute :count, :integer
  attribute :took, :integer
  attribute :error, :string

  def took_in_seconds
    took / 1000.0
  end
end

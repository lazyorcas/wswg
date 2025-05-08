# https://github.com/ankane/searchkick?tab=readme-ov-file#results

class Search::Result
  include StoreModel::Model

  MIN_SCORE = 5

  attribute :hits, Search::Result::Hit.to_array_type
  attribute :count, :integer
  attribute :took, :integer
  attribute :error, :string

  def successful?
    error.blank?
  end

  def took_in_seconds
    took / 1000.0
  end

  def ids
    hits.map { |hit| hit.id }
  end

  def scores
    hits.map { |hit| hit.score }
  end
end

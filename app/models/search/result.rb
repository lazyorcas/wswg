# https://github.com/ankane/searchkick?tab=readme-ov-file#results

class Search::Result
  include StoreModel::Model

  attribute :hits, Search::Result::Hit.to_array_type
  attribute :count, :integer
  attribute :took, :integer
  attribute :error, :string

  def took_in_seconds
    took / 1000.0
  end

  def ids
    hits.map { |hit| hit.id }
  end

  def scores
    hits.map { |hit| hit.score }
  end

  def inlier_ids(outlier_detection_method: :min_score)
    inliers = case outlier_detection_method
    when :min_score
      get_inliers_by_min_score
    when :boxplot
      get_inliers_by_boxplot
    else
      raise "Invalid outlier detection method: #{outlier_detection_method}"
    end

    inliers.map { |hit| hit.id }
  end

  private

  MIN_SCORE = 5
  def get_inliers_by_min_score
    hits.select { |hit| hit.score >= MIN_SCORE }
  end

  def get_inliers_by_boxplot
    return [] if hits.empty?

    sorted_hits = hits.sort_by(&:score).reverse
    scores = sorted_hits.map(&:score)

    median = scores[scores.length / 2]

    above_median_inliers = sorted_hits.select { |hit| hit.score >= median }
    below_median_hits = sorted_hits.select { |hit| hit.score < median }

    inliers = above_median_inliers

    if below_median_hits.any?
      below_median_scores = below_median_hits.map(&:score)
      q1 = below_median_scores[below_median_scores.length / 2]

      iqr = median - q1
      lower_bound = q1 - (1.5 * iqr)

      below_median_inliers = below_median_hits.select { |hit| hit.score >= lower_bound }

      inliers += below_median_inliers
    end

    inliers
  end
end

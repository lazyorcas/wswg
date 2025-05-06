module Statistics
  BOXPLOT_SAMPLE_SIZE_THRESHOLD = 20
  AVG_SAMPLE_SIZE_THRESHOLD = 10
  MIN_VALUE = 5

  def self.calculate_inliers(data)
    inliers = []

    if data.size >= BOXPLOT_SAMPLE_SIZE_THRESHOLD
      inliers = calculate_inliers_by_boxplot(data)

    elsif data.size >= AVG_SAMPLE_SIZE_THRESHOLD
      inliers = calculate_inliers_by_avg(data)

    else
      inliers = calculate_inliers_by_min_value(data)
    end

    inliers
  end

  def self.calculate_inliers_by_avg(data)
    return [] if data.empty?

    values = data.map { |p| p[1] }
    avg_score = values.sum / values.size
    data.select { |p| p[1] >= avg_score }
  end

  def self.calculate_inliers_by_min_value(data)
    return [] if data.empty?

    data.select { |p| p[1] >= MIN_VALUE }
  end

  def self.calculate_inliers_by_boxplot(data)
    return [] if data.empty?

    sorted_data = data.sort_by { |p| p[1] }.reverse
    values = sorted_data.map { |p| p[1] }

    median = values[values.length / 2]

    above_median_inliers = sorted_data.select { |p| p[1] >= median }
    below_median_data = sorted_data.select { |p| p[1] < median }

    inliers = above_median_inliers

    if below_median_data.any?
      below_median_values = below_median_data.map { |p| p[1] }
      q1 = below_median_values[below_median_values.length / 2]

      iqr = median - q1
      lower_bound = q1 - (1.5 * iqr)

      below_median_inliers = below_median_data.select { |p| p[1] >= lower_bound }

      inliers += below_median_inliers
    end

    inliers
  end
end

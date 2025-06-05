require "test_helper"

class GeospatialTest < ActiveSupport::TestCase
  def setup
    @coordinates = cities(:singapore).coordinates
  end

  test "add_noise_to_coords returns coordinates within 5km radius" do
    100.times do
      noisy_coords = Geospatial.add_noise_to_coords(@coordinates)
      distance = Geospatial.distance_in_km_between(@coordinates, noisy_coords)
      assert_operator distance, :<=, Geospatial::NOISE_RADIUS
      assert_operator distance, :>=, 0
    end
  end

  test "add_noise_to_coords produces different results" do
    results = Set.new
    100.times do
      noisy_coords = Geospatial.add_noise_to_coords(@coordinates)
      results << [ noisy_coords[:lat], noisy_coords[:lon] ]
    end

    # Verify we get different results (not all the same point)
    assert_operator results.size, :>, 1
  end
end

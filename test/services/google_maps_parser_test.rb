require "test_helper"

class GoogleMapsParserTest < ActiveSupport::TestCase
  test "parses coordinate-based URL" do
    url = "https://www.google.com/maps/@35.6762,139.6503,15z"
    coords = GoogleMapsParser.parse(url)
    assert_equal 35.6762, coords[:latitude]
    assert_equal 139.6503, coords[:longitude]
  end

  test "parses place URL" do
    url = "https://www.google.com/maps/place/Tokyo/@35.6762,139.6503,15z/data=!3m1!4b1!4m6!3m5!1s0x60188b8576281c4d:0x4e31959ac1c3605c!8m2!3d35.6762!4d139.6503!16zL20vMDdkZms?entry=ttu"
    coords = GoogleMapsParser.parse(url)
    assert_equal 35.6762, coords[:latitude]
    assert_equal 139.6503, coords[:longitude]
  end

  test "returns nil for invalid URL" do
    url = "https://www.google.com"
    assert_nil GoogleMapsParser.parse(url)
  end
end

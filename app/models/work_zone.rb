class WorkZone < ApplicationRecord
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :radius, presence: true, numericality: { greater_than: 0 }

  # Check if a point is within this work zone
  def contains?(lat, lng)
    return false if lat.blank? || lng.blank?

    # Calculate distance using Haversine formula
    distance = calculate_distance(
      latitude, longitude,
      lat.to_f, lng.to_f
    )

    distance <= radius
  end

  private

  # Calculate distance between two points in meters
  def calculate_distance(lat1, lng1, lat2, lng2)
    earth_radius = 6_371_000 # Earth's radius in meters

    lat1_rad = lat1 * Math::PI / 180
    lat2_rad = lat2 * Math::PI / 180
    delta_lat = (lat2 - lat1) * Math::PI / 180
    delta_lng = (lng2 - lng1) * Math::PI / 180

    a = Math.sin(delta_lat / 2) * Math.sin(delta_lat / 2) +
        Math.cos(lat1_rad) * Math.cos(lat2_rad) *
        Math.sin(delta_lng / 2) * Math.sin(delta_lng / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    earth_radius * c
  end
end
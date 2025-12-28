class LocationVerificationService
  include Geokit::Geocoders

  def initialize(user, reported_coordinates, ip_address)
    @user = user
    @reported_coordinates = reported_coordinates
    @ip_address = ip_address
  end

  def verify
    return true if @user.remote_worker?

    ip_location = get_ip_location
    return false unless ip_location

    distance = calculate_distance(@reported_coordinates, ip_location)

    # Flag if distance > 50km (configurable threshold)
    distance <= 50.kilometers
  end

  private

  def get_ip_location
    # Use IP geolocation service
    geocode = MultiGeocoder.geocode(@ip_address)
    return nil unless geocode.success

    [ geocode.lat, geocode.lng ]
  end

  def calculate_distance(coords1, coords2)
    Geokit::LatLng.new(*coords1).distance_to(Geokit::LatLng.new(*coords2))
  end
end

require "net/http"
require "uri"

class GoogleMapsParser
  def self.parse(url)
    return nil if url.blank?

    # Handle short links (maps.app.goo.gl)
    if url.include?("maps.app.goo.gl")
      url = resolve_short_link(url)
      return nil unless url
    end

    # Pattern for @lat,lng
    if url =~ /@(-?\d+\.\d+),(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Pattern for /place/.../lat,lng
    if url =~ /place\/.*\/@(-?\d+\.\d+),(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Pattern for q=lat,lng
    if url =~ /q=(-?\d+\.\d+),(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    nil
  end

  private

  def self.resolve_short_link(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    if response.code == "301" || response.code == "302"
      response["location"]
    else
      nil
    end
  rescue StandardError => e
    Rails.logger.error "GoogleMapsParser Error: #{e.message}"
    nil
  end
end

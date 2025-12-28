require "net/http"
require "uri"

class GoogleMapsParser
  def self.parse(url)
    return nil if url.nil? || url.empty?

    # Handle short links (maps.app.goo.gl or goo.gl/maps)
    if url.include?("goo.gl")
      resolved_url = resolve_short_link(url)
      return nil unless resolved_url
    else
      resolved_url = url
    end

    # Extract coordinates from the resolved URL
    # Look for patterns like @lat,lng in the URL
    if resolved_url =~ /@(-?\d+\.\d+),(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Pattern for /place/.../lat,lng
    if resolved_url =~ /place\/.*\/@(-?\d+\.\d+),(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Pattern for q=lat,lng (URL encoded)
    if resolved_url =~ /q=(-?\d+\.\d+),(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # For search results or direct coordinate searches, try to extract from URL parameters
    if resolved_url =~ /search\?.*q=(-?\d+\.\d+)%2C(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Try to fetch and parse the HTML content for coordinates
    if resolved_url.include?("maps.google.com") || resolved_url.include?("google.com/maps")
      html_coords = extract_from_html(resolved_url)
      return html_coords if html_coords
    end

    nil
  end

  def self.extract_from_html(url)
    # Fetch the HTML content
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    return nil unless response.code == "200"

    html = response.body

    # Look for coordinate patterns in the HTML
    # Pattern 1: "center=lat,lng"
    if html =~ /center=(-?\d+\.\d+),(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Pattern 2: JavaScript variables or data attributes with coordinates
    if html =~ /"lat":(-?\d+\.\d+).*?"lng":(-?\d+\.\d+)/m
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Pattern 3: URL-encoded coordinates in the HTML
    if html =~ /(-?\d+\.\d+)%2C(-?\d+\.\d+)/
      return { latitude: $1.to_f, longitude: $2.to_f }
    end

    # Pattern 4: Look for coordinates in the URL query parameters
    begin
      query_params = URI.parse(url).query
      if query_params
        # Try to decode and find coordinates
        decoded = URI.decode_www_form(query_params).to_h rescue {}
        if decoded['q'] && decoded['q'] =~ /(-?\d+\.\d+),\s*(-?\d+\.\d+)/
          return { latitude: $1.to_f, longitude: $2.to_f }
        end
      end
    rescue
      # Ignore URI parsing errors
    end

    # Pattern 5: Direct coordinate search in HTML (most basic)
    if html =~ /(\d{2}\.\d{6}),(\d{2}\.\d{6})/
      lat, lng = $1.to_f, $2.to_f
      # Basic validation - latitude should be between -90 and 90, longitude between -180 and 180
      if lat.between?(-90, 90) && lng.between?(-180, 180)
        return { latitude: lat, longitude: lng }
      end
    end

    nil
  rescue StandardError => e
    Rails.logger.error "GoogleMapsParser HTML extraction error: #{e.message}"
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

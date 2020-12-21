class ExoPlanetDataFinder

include Constants::Planet
include Constants::Http



def initialize
  reset_instance_variables
end
  
def reset_instance_variables 
  @exo_planet_data = Hash.new
  @timeline_data = Hash.new
  @orphans = 0
  @planet_hottest_star = nil
end

def request_url_parse_data
  begin
    reset_instance_variables
    resp_hash = {}
    uri = URI(EXO_PLANET_URL)
    Net::HTTP.start(uri.host, uri.port,:use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request
      resp_hash = JSON.parse(response.body)
    end
    return resp_hash
  rescue => e
    Log.error "Exception in code, #{e.message}, #{e.backtrace}"
    return {}
  end
end

def create_exo_planet_obj(data)
  begin
    exo_planet = ExoPlanet.new(data)
    exo_planet_identifier = exo_planet.identifier
    unless exo_planet_identifier.nil?
      @exo_planet_data[exo_planet_identifier] = exo_planet
      return exo_planet
    else
      return nil
    end
  rescue => e
    Log.error "Exception in code, #{e.message}, #{e.backtrace}"
    return nil
  end
end

def find_hottest_star_exo_planet(exo_planet)
  host_star_temp = exo_planet.host_star_temp
  if !exo_planet.nil? && !exo_planet.is_orphan? && !host_star_temp.nil?
    if @planet_hottest_star.nil? || host_star_temp > @planet_hottest_star.host_star_temp
      @planet_hottest_star = exo_planet
    end
  end
end

def find_discovery_timeline(exo_planet)
  discovery_year = exo_planet.discovery_year
  if discovery_year 
    unless @timeline_data.key?(discovery_year)
      @timeline_data[discovery_year] = {PLANET_SIZE_SMALL => 0, PLANET_SIZE_MEDIUM => 0, PLANET_SIZE_LARGE => 0}
    end
    planet_size_type = exo_planet.planet_size_type
    if planet_size_type
      @timeline_data[discovery_year][planet_size_type] += 1
    end
  end
end

def calculate_orphan_count(exo_planet)
  @orphans += 1 if exo_planet.is_orphan?
end

def find_exoplanet_information
  # Retrieved Data Stored for any further processing
  @orphans = 0
  resp_hash = request_url_parse_data
  resp_hash.each{|resp|
    begin
      exo_planet = create_exo_planet_obj(resp)
      find_hottest_star_exo_planet(exo_planet)
      calculate_orphan_count(exo_planet)
      find_discovery_timeline(exo_planet)
    rescue => e
      LOG.err "#{e.message}, #{e.backtrace}"  
    end
  }
  Log.info "1.	The number of orphan planets is #{@orphans}"
  Log.info "2.	The name of the planet orbiting the hottest star is #{@planet_hottest_star.identifier}"
  Log.info "3.	The timeline data is"
  @timeline_data.keys.sort.each{|year|
    Log.info "  	In year #{year}, there were #{@timeline_data[year][PLANET_SIZE_SMALL]} small planets, #{@timeline_data[year][PLANET_SIZE_MEDIUM]} medium planets, #{@timeline_data[year][PLANET_SIZE_LARGE]} large planets discovered."  
  }
end

end
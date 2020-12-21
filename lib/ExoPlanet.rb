class ExoPlanet
  include Constants::Planet
  attr_reader :identifier,:type,:host_star_temp,:radius,:discovery_year
  
  def initialize(data_map)
    data_map.each{|field,value|
      case field
      when IDENTIFIER_KEY
        if value.nil? || value.empty? 
          raise "Invalid Identifier"
        end
        @identifier = value
      when TYPE_FLAG_KEY
        @type = value
      when HOST_STAR_TEMP_KELVIN_KEY
        @host_star_temp = value.to_f
      when RADIUS_KEY
        @radius = value.to_f
      when DISCOVERY_YEAR_KEY
        # Some planets (like transit) do not have discovery year
        next if value == "" 
        @discovery_year = value.to_i
      end
    }
  end
  
  def is_orphan?
    @type == TYPE_FLAG_ORPHAN
  end
  
  def planet_size_type
    type = nil
    if !@radius.nil? && @radius > 0
     if @radius < 1
       type = PLANET_SIZE_SMALL
     elsif @radius < 2
       type = PLANET_SIZE_MEDIUM
     else
       type = PLANET_SIZE_LARGE
     end 
    end
    return type
  end
  
  
end
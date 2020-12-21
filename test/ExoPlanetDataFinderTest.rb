class ExoPlanetDataFinderTest < Minitest::Test
  def setup
    @test = ExoPlanetDataFinder.new
  end

  def test_initialize
    assert(@test.is_a?(ExoPlanetDataFinder))
    assert_equal(@test.instance_variable_get(:@exo_planet_data), {})
    assert_equal(@test.instance_variable_get(:@timeline_data) ,{})
    assert_equal(@test.instance_variable_get(:@orphans),0)
    assert_nil(@test.instance_variable_get(:@planet_hottest_star))
  end
 
  def test_create_exo_planet_obj
    data_map = {'PlanetIdentifier'=>'Planet_Name','TypeFlag'=>1,'HostStarTempK'=>1290,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj = @test.create_exo_planet_obj(data_map)
    assert(exo_planet_obj.is_a?(ExoPlanet))
    assert_equal(exo_planet_obj.instance_variable_get(:@identifier),'Planet_Name')
    assert_equal(exo_planet_obj.instance_variable_get(:@type),1)
    assert_equal(exo_planet_obj.instance_variable_get(:@host_star_temp),1290)
    assert_equal(exo_planet_obj.instance_variable_get(:@radius),2)
    assert_equal(exo_planet_obj.instance_variable_get(:@discovery_year),1996)
    planets_map = @test.instance_variable_get(:@exo_planet_data)
    assert(planets_map.key?('Planet_Name'))
    assert_equal(planets_map['Planet_Name'],exo_planet_obj)
  end
  
  def test_create_exo_planet_obj_identifier_nil
    data_map = {'PlanetIdentifier'=>nil,'TypeFlag'=>1,'HostStarTempK'=>1290,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj = @test.create_exo_planet_obj(data_map)
    assert_nil(exo_planet_obj)
    planets_map = @test.instance_variable_get(:@exo_planet_data)
    assert_equal(planets_map,{})
  end

  def test_find_hottest_star_exo_planet
    data_map = {'PlanetIdentifier'=>'Planet_Name','TypeFlag'=>1,'HostStarTempK'=>1290,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj = @test.create_exo_planet_obj(data_map)
    data_map = {'PlanetIdentifier'=>'Planet_Name2','TypeFlag'=>1,'HostStarTempK'=>1390,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj_hotter = @test.create_exo_planet_obj(data_map)
    @test.instance_variable_set(:@planet_hottest_star, exo_planet_obj)
    @test.find_hottest_star_exo_planet(exo_planet_obj_hotter)
    assert_equal(@test.instance_variable_get(:@planet_hottest_star),exo_planet_obj_hotter)
  end
 
  def test_find_hottest_star_exo_planet_orphan
    data_map = {'PlanetIdentifier'=>'Planet_Name','TypeFlag'=>1,'HostStarTempK'=>1290,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj = @test.create_exo_planet_obj(data_map)
    data_map = {'PlanetIdentifier'=>'Planet_Name2','TypeFlag'=>3,'HostStarTempK'=>1390,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj_hotter_orphan = @test.create_exo_planet_obj(data_map)
    @test.instance_variable_set(:@planet_hottest_star, exo_planet_obj)
    @test.find_hottest_star_exo_planet(exo_planet_obj_hotter_orphan)
    assert_equal(@test.instance_variable_get(:@planet_hottest_star),exo_planet_obj)
  end
 
  def test_find_discovery_timeline
    data_map = {'PlanetIdentifier'=>'Planet_Name','TypeFlag'=>1,'HostStarTempK'=>1290,'RadiusJpt'=>0.99,'DiscoveryYear'=> 1996}
    exo_planet_obj_small = @test.create_exo_planet_obj(data_map)
    data_map = {'PlanetIdentifier'=>'Planet_Name2','TypeFlag'=>3,'HostStarTempK'=>1390,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj_large = @test.create_exo_planet_obj(data_map)
    @test.find_discovery_timeline(exo_planet_obj_small)
    timeline_data = @test.instance_variable_get(:@timeline_data)
    assert_equal(timeline_data[1996]['small'],1)
    assert_equal(timeline_data[1996]['large'],0)
    @test.find_discovery_timeline(exo_planet_obj_large)
    timeline_data = @test.instance_variable_get(:@timeline_data)
    assert_equal(timeline_data[1996]['small'],1)
    assert_equal(timeline_data[1996]['large'],1)
    data_map = {'PlanetIdentifier'=>'Planet_Name2','TypeFlag'=>3,'HostStarTempK'=>1390,'RadiusJpt'=>-2,'DiscoveryYear'=> 1996}
    exo_planet_obj_invalid = @test.create_exo_planet_obj(data_map)
    @test.find_discovery_timeline(exo_planet_obj_invalid)
    timeline_data = @test.instance_variable_get(:@timeline_data)
    assert_equal(timeline_data[1996]['small'],1)
    assert_equal(timeline_data[1996]['large'],1)
  end
  
end
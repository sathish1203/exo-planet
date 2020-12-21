class ExoPlanetTest < Minitest::Test

  def test_initialize_sample_values
    data_map = {'PlanetIdentifier'=>'Planet_Name','TypeFlag'=>1,'HostStarTempK'=>1290,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
    exo_planet_obj = ExoPlanet.new(data_map)
    assert(exo_planet_obj.is_a?(ExoPlanet))
    assert_equal(exo_planet_obj.instance_variable_get(:@identifier),'Planet_Name')
    assert_equal(exo_planet_obj.instance_variable_get(:@type),1)
    assert_equal(exo_planet_obj.instance_variable_get(:@host_star_temp),1290)
    assert_equal(exo_planet_obj.instance_variable_get(:@radius),2)
    assert_equal(exo_planet_obj.instance_variable_get(:@discovery_year),1996)
  end
 
  def test_initialize_edge_case
    data_map = {'PlanetIdentifier'=>'SomeIdentifier','TypeFlag'=>'RandomFlag','HostStarTempK'=>nil,'RadiusJpt'=>nil,'DiscoveryYear'=> nil}
    exo_planet_obj = ExoPlanet.new(data_map)
    assert(exo_planet_obj.is_a?(ExoPlanet))
    assert_equal(exo_planet_obj.instance_variable_get(:@identifier),'SomeIdentifier')
    assert_equal(exo_planet_obj.instance_variable_get(:@type),'RandomFlag')
    assert_equal(exo_planet_obj.instance_variable_get(:@host_star_temp),0)
    assert_equal(exo_planet_obj.instance_variable_get(:@radius),0)
    assert_equal(exo_planet_obj.instance_variable_get(:@discovery_year),0)
  end
  
  def test_planet_size_type
    radii = {
      0.1 => 'small',
      0.25 => 'small',
      1 => 'medium',
      1.2 => 'medium',
      2 => 'large',
      2.4 => 'large',
      -1 => nil,
      0 => nil
    }
    radii.each{|radius, expected|
      data_map = {'PlanetIdentifier'=>'Planet_Name','TypeFlag'=>1,'HostStarTempK'=>1290,'RadiusJpt'=>2,'DiscoveryYear'=> 1996}
      exo_planet_obj = ExoPlanet.new(data_map)
      # Excluding the assert for the object attributes as the same values are tested as part of another test case
      exo_planet_obj.instance_variable_set(:@radius, radius)
      actual = exo_planet_obj.planet_size_type
      assert_equal(actual, expected)
    }
  end
 
end
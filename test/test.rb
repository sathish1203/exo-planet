require 'minitest/autorun'
require 'logger'

require '../lib/Constants'
require '../lib/ExoPlanet'
require '../lib/ExoPlanetDataFinder'

Log = Logger.new(STDOUT)
Log.level = Logger::INFO

require './ExoPlanetTest'
require './ExoPlanetDataFinderTest'

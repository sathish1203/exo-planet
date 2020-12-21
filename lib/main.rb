require 'net/http'
require 'openssl'
require 'json'
require 'logger'
current_abs_file_path = File.expand_path('../', __FILE__)
require File.join(current_abs_file_path,'Constants')
require File.join(current_abs_file_path,'ExoPlanet')
require File.join(current_abs_file_path,'ExoPlanetDataFinder')

Log = Logger.new(STDOUT)
Log.level = Logger::INFO

ExoPlanetDataFinder.new.find_exoplanet_information
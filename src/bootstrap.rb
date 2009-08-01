require 'rubygems'

ROOT_PATH = File.expand_path("#{File.dirname(__FILE__)}/../")
$LOAD_PATH << "#{ROOT_PATH}/src"

load "#{ROOT_PATH}/src/logger.rb"

Logger.level = :info
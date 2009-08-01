require 'rubygems'
require 'xmlsimple'

config = XmlSimple.xml_in('map/test.tmx')

# 
# raw_map = ""
# File.open('map/test.js', 'r') {|file| while !file.eof?; raw << file.gets; end }
# 
# map = JSON.parse(map)
p config["layer"].first
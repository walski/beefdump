#Boot strap the system (set load pathes, require rubygems...)
require 'src/bootstrap.rb'

require 'map/map'

m = Map::Map.load('test')


# 
# class MyWindow < Gosu::Window
#   def initialize
#     super(640, 480, false)
#     self.caption = 'Hello World!'
#   end
# end
# 
# w = MyWindow.new
# w.show
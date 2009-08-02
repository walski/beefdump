#Boot strap the system (set load pathes, require rubygems...)
require 'src/bootstrap.rb'

require 'world/world'
require 'map/map'

World.load

m = Map.load('test')

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
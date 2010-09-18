module Beefdump
  module Client
    module Graphical
      require 'gosu'
      class Window < Gosu::Window
        WIDTH  = 640
        HEIGHT = 480
      
        def initialize(client, *args)
          super(*args)
          @client = client
        end
      
        def update
          @client.update_window
        end
      
        def draw
          @client.draw_window
        end
      end
    end
  end
end
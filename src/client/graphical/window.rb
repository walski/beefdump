module Client
  module Graphical
    require 'gosu'
    class Window < Gosu::Window
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
    
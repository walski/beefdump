module Client
  module Graphical
    class Client < Client::Base
      require 'client/graphical/window'
    
      def initialize(game)
        super(game)
        @window = Window.new(self, 640, 480, false)
        @window.caption = Time.now
      
        start_main_loop
      end
    
      def act
        @window.caption = Time.now
      end
    
      def disconnect
        @window.close
        @window_thread.join
      end
    
      def update_window
        if @window.button_down? Gosu::Button::KbEscape
          @game.shutdown!
          @window.close
          @window_thread.join
        end
      end
      
      def draw_window
      end
    
      protected
      def start_main_loop
        @window_thread = Thread.new do
          @window.show
        end
      end
   end 
  end
end
module Client
  module Graphical
    class Client < Client::Base
      require 'gosu'
      require 'client/graphical/window'
    
      def initialize(game, *options)
        super(game, *options)
        @window = Window.new(self, Window::WIDTH, Window::HEIGHT, false)
        @window.caption = Time.now
        
        initialize_tilesets(game.map)
      
        @player = @game.claim_player("Peter", self)
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
        end
        handle_camera_movement
      end
      
      def draw_window
        left   = @player.position.x / @game.map.tile_width
        top    = @player.position.y  / @game.map.tile_height
        diff_x = @player.position.x % @game.map.tile_width
        diff_y = @player.position.y  % @game.map.tile_height
        width  = Window::WIDTH  / @game.map.tile_width  + 1
        height = Window::HEIGHT / @game.map.tile_height + 1
        
        tile_layers = @game.map.background_at(left, top, width, height)
        
        tile_layers.each do |tile_layer|
          tile_layer.each_with_index do |row, x|
            row.each_with_index do |tile, y|
              tileset = @game.map.tileset_for(tile)
              next unless tileset
              tile_id = tile - tileset.first_gid
              @tileset_images[@game.map.tilesets.index(tileset)][tile_id].draw(x * @game.map.tile_width - diff_x, y * @game.map.tile_height - diff_y, 0)
            end
          end
        end
      end
    
      protected
      def start_main_loop
        Thread.abort_on_exception = true
        @window_thread = Thread.new do
          @window.show
        end
      end
      
      def initialize_tilesets(map)
        @tileset_images = []
        map.tilesets.each do |tileset|
          log(:trace, "Loading tileset image '#{tileset.image_file}'")
          @tileset_images << Gosu::Image.load_tiles(@window, tileset.image_file, tileset.tile_width, tileset.tile_height, true)
          log(:trace, "Loaded #{@tileset_images.last.size} tiles.")
        end
      end
      
      def handle_camera_movement
        if @window.button_down? Gosu::Button::KbRight
          @player.position.x = [(@game.map.width * @game.map.tile_width) - Window::WIDTH, @player.position.x + 5].min
        end
        if @window.button_down? Gosu::Button::KbLeft
          @player.position.x = [0, @player.position.x - 5].max
        end
        
        if @window.button_down? Gosu::Button::KbDown
          @player.position.y = [(@game.map.height * @game.map.tile_height) - Window::HEIGHT, @player.position.y + 5].min
        end
        if @window.button_down? Gosu::Button::KbUp
          @player.position.y = [0, @player.position.y - 5].max
        end
      end
   end 
  end
end

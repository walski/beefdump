module Beefdump
  module Map
    class Tileset
      attr_reader :name, :first_gid, :tile_width, :tile_height, :image_file, :image_transparency_color, :map, :dimensions, :tiles_count
    
      def initialize(tileset_data, map)
        @map = map
      
        load_tileset_attributes!(tileset_data)
        load_image!(tileset_data["image"].first)
      end
    
      protected
    
      def load_tileset_attributes!(tileset_data)
        @name        = tileset_data["name"]
        @first_gid   = tileset_data["firstgid"].to_i
        @tile_width  = tileset_data["tilewidth"].to_i
        @tile_height = tileset_data["tileheight"].to_i
      
        Logger.trace "Loaded tileset attributes: Name: '#{@name}' First GID: #{@first_gid} Tile Width: #{@tile_width} Tile Height: #{@tile_height}"
      end
    
      def load_image!(image_data)
        @image_file = File.expand_path("#{MAP_PATH}/#{image_data["source"]}")
        @image_transparency_color = image_data["trans"]
      
        @dimensions  = ImageUtil.dimensions(@image_file)
        @tiles_count = @dimensions.first * @dimensions.last / (@tile_width * @tile_height)
      
        Logger.trace "Loaded tileset image data: File '#{@image_file}' Mask Color: #{@image_transparency_color} Dimensions: #{@dimensions.join(" * ")} Tiles: #{@tiles_count}"
      end
    end
  end
end
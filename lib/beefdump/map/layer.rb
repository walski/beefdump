module Beefdump
  module Map
    class Layer
      require 'zlib'
      require 'base64'
    
      attr_reader :name, :width, :height, :map, :field
    
      def initialize(layer_data, map)
        @map = map
      
        load_layer_attributes!(layer_data)
      
        load_data!(layer_data["data"].first)
      end
    
      protected
      def load_layer_attributes!(layer_data)
        @name   = layer_data["name"]
        @width  = layer_data["width"].to_i
        @height = layer_data["height"].to_i
      
        Logger.trace "Loaded layer attributes: Name: #{@name} Width: #{@width} Height: #{@height}"
      end
    
      def load_data!(data)
        Logger.trace "Loading layer data for layer '#{@name}'."
      
        encoding    = data["encoding"]
        compression = data["compression"]
      
        raise "Map layers without BASE64 enconding are unsupported!" unless encoding == "base64"
        raise "Map layers without GZIP compression are unsupported!" unless compression == "gzip"
      
        content = StringIO.new(Base64.decode64(data["content"].strip))
        gz = Zlib::GzipReader.new(content)
      
        @field = []
        row = []
        byte_arr = []
        gz.each_byte do |byte|
          byte_arr << byte
          if byte_arr.size == 4
            row << (byte_arr[0] | byte_arr[1] << 8 | byte_arr[2] << 16 | byte_arr[3] << 24)
            byte_arr = []
            @field << row and row = [] if row.size == @width
          end
        end
        gz.close
      end
    end
  end
end
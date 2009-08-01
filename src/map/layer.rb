module Map
  class Layer
    require 'zlib'
    require 'base64'
    
    def initialize(layer_data)
      load_layer_attributes!(layer_data)
      
      load_data!(layer_data["data"].first)
    end
    
    protected
    def load_layer_attributes!(layer_data)
      @name   = layer_data["name"]
      @width  = layer_data["width"]
      @height = layer_data["height"]
    end
    
    def load_data!(data)
      p data
      encoding    = data["encoding"]
      compression = data["compression"]
      
      raise "Map layers without BASE64 enconding are unsupported!" unless encoding == "base64"
      raise "Map layers without GZIP compression are unsupported!" unless compression == "gzip"
      
      content = StringIO.new(Base64.decode64(data["content"].strip))
      gz = Zlib::GzipReader.new(content)
      gz.each_byte {|byte| p byte}
      gz.close
    end
  end
end
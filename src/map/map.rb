module Map
  class Map
    require 'xmlsimple'
    require 'map/layer'
    
    MAP_FOLDER = "#{ROOT_PATH}/map"
    MAP_FORMAT_VERSION = "1.0"
  
    attr_reader :width, :height, :tile_width, :tile_height
  
    def initialize(map_data)
      check_compatibility!(map_data)
    
      load_map_attributes!(map_data)
      load_layers!(map_data)
      @raw_data = map_data
    end
  
    def self.load(map_name)
      map_file = "#{MAP_FOLDER}/#{map_name}.tmx"
      raise "Map does not exist: '#{map_file}'!" unless File.exist?(map_file)
    
      self.new(XmlSimple.xml_in(map_file))
    end
  
  
    protected
    def check_compatibility!(map_data)
      raise "Map format unsupported (#{map_data["orientation"]})!" unless map_data["orientation"] == "orthogonal"
      Logger.warn("Map format version #{map_data['version']} is not supported - scary problems may occur! Supply maps in format version #{MAP_FORMAT_VERSION} to ensure smooth operation.") if map_data['version'] != MAP_FORMAT_VERSION
    end
  
    def load_map_attributes!(map_data)
      @width       = map_data["width"]
      @height      = map_data["height"]
      @tile_width  = map_data["tile_width"]
      @tile_height = map_data["tile_height"]
    end
  
    def load_layers!(map_data)
      @layers = map_data["layer"].map {|layer_data| Layer.new(layer_data)}
    end
  
  end
end
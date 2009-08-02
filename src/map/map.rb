module Map
  MAP_FOLDER = "#{ROOT_PATH}/map"
  
  class Map
    require 'xmlsimple'
    require 'map/layer'
    require 'map/tileset'
    require 'map/object'
    
    MAP_FORMAT_VERSION = "1.0"
  
    attr_reader :width, :height, :tile_width, :tile_height, :layers, :tilesets, :objects
  
    def initialize(map_data)
      check_compatibility!(map_data)
    
      load_map_attributes!(map_data)
      load_layers!(map_data)
      load_tilesets!(map_data)
      load_objects!(map_data)

      @raw_data = map_data
    end
    
    def background_for(x, y, width, height)
    end
    
    def objects_at(x, y)
      objects = []
      
      @layers.each do |layer|
        
      end
    end
  
    protected
    def check_compatibility!(map_data)
      Logger.trace "Checking map format compatibility."
      
      raise "Map format unsupported (#{map_data["orientation"]})!" unless map_data["orientation"] == "orthogonal"
      Logger.warn("Map format version #{map_data['version']} is not supported - scary problems may occur! Supply maps in format version #{MAP_FORMAT_VERSION} to ensure smooth operation.") if map_data['version'] != MAP_FORMAT_VERSION
    end
  
    def load_map_attributes!(map_data)
      @width       = map_data["width"].to_i
      @height      = map_data["height"].to_i
      @tile_width  = map_data["tile_width"].to_i
      @tile_height = map_data["tile_height"].to_i
      
      Logger.trace "Loaded map attributes: Width: #{@width} Height: #{@height} Tile Width: #{@tile_width} Tile Height: #{@tile_height}"
    end
  
    def load_layers!(map_data)
      @layers = map_data["layer"].map {|layer_data| Layer.new(layer_data, self)}
      
      Logger.info "Loaded #{@layers.size} map layers."
    end
    
    def load_tilesets!(map_data)
      @tilesets = map_data["tileset"].map {|tileset_data| Tileset.new(tileset_data, self)}
      
      Logger.info "Loaded #{@tilesets.size} tilesets containing #{@tilesets.inject(0) {|a,t| a += t.tiles_count}} tiles at all."
    end
    
    def load_objects!(map_data)
      @objects = []
      map_data["objectgroup"].each do |object_group|
        object_group["object"].each do |object|
          new_object = Object.new(object)
          raise "Duplicate object name on map: #{new_object.name}" if @objects.any? {|o| o.name == new_object.name}
          @objects << new_object
        end
      end
      
      check_object_reference_integrity
      
      Logger.info "Loaded #{@objects.size} objects on the map."
    end
    
    def check_object_reference_integrity
      Logger.info "Checking reference integrity on objects."
      
      @objects.each do |object|
        object.properties.each do |property, value|
          if object.blueprint.properties[property].type == :name_reference
            raise "Object '#{object.name}' references to an object named '#{value}' as it's '#{property}' value but such an object does not exist!" unless @objects.any? {|o| o.name == value}
          end
        end
      end
      
    end
  
  end
  
  def self.load(map_name)
    Logger.info "Trying to load map #{map_name}"
    
    map_file = "#{MAP_FOLDER}/#{map_name}.tmx"
    raise "Map does not exist: '#{map_file}'!" unless File.exist?(map_file)
  
    map = Map.new(XmlSimple.xml_in(map_file))

    Logger.info "Successfully loaded map."
    map
  end
  
end
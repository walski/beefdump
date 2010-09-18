module Beefdump
  module Map
    class Object
      attr_reader :name, :x, :y, :width, :height, :type, :properties, :blueprint
    
      def initialize(object_data)
        load_object_attributes!(object_data)
      
        load_properties!(object_data["properties"])
      end
    
      def is_at?(x, y)
        self.x >= x && self.x + self.width <= x && self.y >= y && self.y + self.height <= y
      end
    
      protected
      def load_object_attributes!(object_data)
        @type = object_data["type"].to_sym
        @blueprint = World.objects[@type]
        raise "Unsupported object type '#{@type}' on map!" unless @blueprint
      
        @name   = object_data["name"]
        @x      = object_data["x"]
        @y      = object_data["y"]
        @width  = object_data["width"]
        @height = object_data["height"]
      
        Logger.trace "Loaded object attributes: Name: #{@name} Position: #{@x}, #{@y} Width: #{@width} Height: #{@height} Type: #{@type}"
      end
    
      def load_properties!(properties_data)
        @properties = {}
        return unless properties_data

        properties_data.first["property"].each do |property_data|
          value = check_and_cast_property(property_data["property"])
          @properties[property_data["name"].to_sym] = property_data["value"]
        end
      
        check_for_mandatory_properties
      
        Logger.trace "Sucessfully loaded properties for object '#{@name}'."
      end
    
      def check_and_cast_property(property_data)
        return unless property_data

        property_name = property_data["name"].to_sym
        property_blueprint = @blueprint.properties[property_name]
        raise "Object type '#{@type}' has no '#{property_name}' property (on object '#{@name}')" unless property_blueprint
      
        value = property_data["value"]
        return nil unless value
      
        case property_blueprint.type
        when :number
          raise "Value of property '#{property_name}' on object '#{@name}' must be numeric and not #{value}!" unless value.numeric?
          value.to_f
        when :string
          value.to_s
        when :name_reference
          value.to_s
        end
      end
    
      def check_for_mandatory_properties
        @blueprint.properties.each do |type, property|
          next unless property.mandatory?

          raise "Mandatory property '#{property.name}' not set on object '#{@name}' of type #{@type}!" unless @properties[property.name]
        end
      end
    end
  end
end
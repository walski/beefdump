module Beefdump
  module World
    class Object < Entity
      require 'beefdump/world/object_property'
    
      attr_reader :type, :properties
    
      def initialize(object_data)
        load_object_attributes!(object_data)
      
        load_properties!(object_data["property"])
      end
    
      protected
      def load_object_attributes!(object_data)
        raise "Objects must have a type!" unless @type = object_data["type"].to_sym
      end
    
      def load_properties!(properties)
        return unless properties
      
        @properties = {}
        properties.each do |property|
          load_property!(property)
        end
      end
    
      def load_property!(property)
        mandatory = property["mandatory"]
        mandatory = mandatory.downcase == "true" if mandatory

        name = property["name"].to_sym
        @properties[name] = ObjectProperty.new(name, property["type"], mandatory) 
      end
    end
  end
end
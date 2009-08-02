module World
  class ObjectProperty
    TYPES = [:number, :string, :name_reference]
    
    attr_reader :name, :type
    
    def initialize(name, type, mandatory = false)
      raise "Any object property need a name!" unless @name = name
      
      raise "Object property '#{@name}' has not type. Any property needs a type!" unless type 
      type = type.to_sym
      raise "Object property type '#{type}' is not supported! Use one of: #{TYPES.join(',')}." unless TYPES.include?(type)
      @type = type
      
      @mandatory = !!mandatory
    end
    
    def mandatory?
      @mandatory
    end
  end
end
module World
  require 'xmlsimple'
  require 'world/object'
  
  def self.load
    objects_file = "#{CONFIG_PATH}/objects.xml"
    raise "Objects configuration missing! Please supply '#{objects_file}'." unless File.exist?(objects_file)

    raise "Object configuration format invalid!" unless objectset = XmlSimple.xml_in(objects_file)["object"]
    @objects = {}
    objectset.each do |object_data|
      object = Object.new(object_data)
      @objects[object.type] = object
    end
  end
  
  def self.objects
    @objects
  end
end
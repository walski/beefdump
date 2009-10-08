class Logger
  LEVELS = [:trace, :info, :warn, :error]
  
  def self.level=(new_level)
    raise "No valid log level: '#{new_level}'!" unless @level = LEVELS.index(new_level)
  end
  
  def self.method_missing(method_name, *args)
    return super.send(method_name, args) unless LEVELS.include?(method_name)
    log(method_name, args.first) if LEVELS.index(method_name) >= @level
  end
  
  protected
  def self.log(level, message)
    puts "[#{level}] #{Time.now}: #{message}"
  end
end
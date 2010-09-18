module Beefdump
  # Bootstrap helpers
  def self.load_dir(dir)
    Dir.new(dir).each do |file|
      next unless file =~ /\.rb$/
      load "#{dir}/#{file}"
    end
  end

  # Load path
  LIB_PATH = File.expand_path(File.dirname(__FILE__))
  $LOAD_PATH << LIB_PATH

  # Monkey patches
  load_dir("#{LIB_PATH}/beefdump/monkey_patches")
end
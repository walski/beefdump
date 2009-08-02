require 'rubygems'

# ROOT Path
ROOT_PATH = File.expand_path("#{File.dirname(__FILE__)}/../")
SRC_PATH = "#{ROOT_PATH}/src"
$LOAD_PATH << SRC_PATH

# Logger
load "#{SRC_PATH}/logger.rb"
Logger.level = :info

def load_dir(dir)
  Dir.new(dir).each do |file|
    next unless file =~ /\.rb$/
    load "#{dir}/#{file}"
  end
end

# Monkey patches
MONKEY_PATCHES_PATH = "#{SRC_PATH}/monkey_patches"
Logger.info "Loading monkey patches."
load_dir(MONKEY_PATCHES_PATH)

# Utils
UTILS_PATH = "#{SRC_PATH}/utils"
Logger.info "Loading utils."
load_dir(UTILS_PATH)

# Config
CONFIG_PATH = "#{ROOT_PATH}/config"

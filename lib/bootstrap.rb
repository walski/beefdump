require 'rubygems'
require 'ostruct'

# Bootstrap helpers
def load_dir(dir)
  Dir.new(dir).each do |file|
    next unless file =~ /\.rb$/
    load "#{dir}/#{file}"
  end
end

# ROOT Path
ROOT_PATH = File.expand_path("#{File.dirname(__FILE__)}/../")
LIB_PATH = "#{ROOT_PATH}/lib"
$LOAD_PATH << LIB_PATH

# Monkey patches
MONKEY_PATCHES_PATH = "#{LIB_PATH}/monkey_patches"
load_dir(MONKEY_PATCHES_PATH)

# Config
CONFIG_PATH = "#{ROOT_PATH}/config"
CONFIG = OpenStruct.new(
  :active_modules => %w{world map client/base client/graphical/client},
  :logger => OpenStruct.new(
    :class => "#{LIB_PATH}/logger.rb",
    :level => :info
  )
)
base_config = "#{CONFIG_PATH}/base.rb"
load base_config if File.exist?(base_config)

# Logger
load CONFIG.logger.class
Logger.level = CONFIG.logger.level
Logger.info "Monkey patches, config and logger loaded. Let's get going!"

# Utils
UTILS_PATH = "#{LIB_PATH}/utils"
Logger.info "Loading utils."
load_dir(UTILS_PATH)

# Game
Logger.info "Loading game kernel"
load "#{LIB_PATH}/game/base.rb"

# Modules
CONFIG.active_modules.each do |modul|
  require "#{modul}#{modul =~ /.+\/.+/ ? "" : "/#{modul}"}"
end
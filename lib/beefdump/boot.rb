module Beefdump
  require 'ostruct'

  # Config
  require 'beefdump/config/base'
  CONFIG_PATH = "#{ROOT_PATH}/config"
  CONFIG = Config::Base.new
  # load beefdump config blueprint
  require 'beefdump/config/blueprint'
  
  base_config = "#{CONFIG_PATH}/base.rb"
  load base_config if File.exist?(base_config)

  # Logger
  load CONFIG.logger.class
  Logger.level = CONFIG.logger.level
  Logger.info "Monkey patches, config and logger loaded. Let's get going!"

  # Utils
  UTILS_PATH = "#{LIB_PATH}/beefdump/utils"
  Logger.info "Loading utils."
  load_dir(UTILS_PATH)

  # Game
  Logger.info "Loading game kernel"
  load "#{LIB_PATH}/beefdump/game/base.rb"

  # Modules
  Logger.info "Loading beefdump modules"
  CONFIG.active_modules.each do |modul|
    Logger.trace "Loading module #{modul}"
    require "beefdump/#{modul}#{modul =~ /.+\/.+/ ? "" : "/#{modul}"}"
  end
  Logger.info "Loading of modules completed"
end
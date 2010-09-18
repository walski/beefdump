module Beefdump
  CONFIG.active_modules = %w{world map client/base client/graphical/client}

  CONFIG.logger = Config::Base.new(
    :class => "beefdump/logger.rb",
    :level => :info)
end
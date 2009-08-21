# This is called before anything which uses the config is called so use it
# as a point to safely customize the CONFIG hash.

# Remove the active modules like this:
# CONFIG.active_modules.delete('map') # Prevents loading of the map module

# Customize the logger:
# 1. Change the log level:
# CONFIG.logger.level = :error # Changes the log level to :error. See logger.rb for available log levels.
# 2. Change the logger itself:
# CONFIG.logger.class = "#{SRC_PATH}/my_fance_logger.rb" # Changes the used class to log messages.
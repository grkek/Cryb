require "./logging"
require "./config"
require "./motd"
require "./commands/*"

require "discordcr"
require "logger"

module Cryb
  CONFIG = Config.parse

  Logging.motd MOTD.random

  @@bot_logger = Logger.new(STDOUT, level: Logger::WARN)

  @@bot_logger.formatter = Logger::Formatter.new do |severity, _, _, message, _|
    label = severity.unknown? ? "ANY" : severity.to_s
    # Is this a hack?
    if message.ends_with? "Authentication failed."
      Logging.fatal "Authentication failed (Your token is probably invalid.) " \
        "Validate your config file?"
      exit 2
    end
    
    case label[0]
    when "W"
      Logging.warning message
    else
      Logging.fatal message
    end
  end

  BOT = Discord::Client.new(
    token: "Bot #{CONFIG.token}",
    logger: @@bot_logger,
  )

  cache = Discord::Cache.new(BOT)
  BOT.cache = cache
  
  BOT.run
end
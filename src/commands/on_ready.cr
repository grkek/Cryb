require "../version"

module Cryb
  module OnReady
    BOT.on_ready do |payload|
      Logging.info "Starting Cryb #{VERSION} as #{payload.user.username}#" \
        "#{payload.user.discriminator} (prefix '#{CONFIG.prefix}')"

      Logging.info "Invite with https://discordapp.com/api/oauth2/authorize?" \
        "client_id=665715988247085147&permissions=3213376&scope=bot"
    end
  end
end
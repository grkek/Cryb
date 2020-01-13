module Cryb
  module Status
    command_base = "#{CONFIG.prefix}set status"
    BOT.on_message_create do |payload|
      next if payload.author.bot || !payload.content.starts_with? command_base
      
      new_status = payload.content.split(command_base)[1]
      
      BOT.create_message payload.channel_id, "It do be like that."
      BOT.status_update(game: Discord::GamePlaying.new(name: new_status, type: 3_i64))
    end
  end
end
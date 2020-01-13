module Cryb
  module Cheating
    command_base = "#{CONFIG.prefix}is the person that just killed me cheating"
    BOT.on_message_create do |payload|
      next if payload.author.bot || !payload.content.downcase.starts_with? command_base
      
      BOT.create_message(payload.channel_id, "Yes, no one could kill you legitimately.")
    end
  end
end
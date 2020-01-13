module Cryb
  module ShutUp
    BOT.on_message_create do |payload|
      next if payload.author.bot || payload.content.starts_with? CONFIG.prefix
      
      if Random.rand(0..3) == 2
        BOT.create_message(payload.channel_id, "<@#{payload.author.id}> Shutup")
      end
    end
  end
end
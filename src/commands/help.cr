require "./embeds/*" # Colours

require "discordcr"

module Cryb
  module Help

    command_base = "#{CONFIG.prefix}help"
    BOT.on_message_create do |payload|
      next if payload.author.bot || !payload.content.starts_with? command_base
      
      help_embed = Discord::Embed.new(
        title: "Prefix: #{CONFIG.prefix}",
        description: "Version #{VERSION}",
        colour: Embeds::Colors.info,

        author: Discord::EmbedAuthor.new(
          name: "Cryb",
          icon_url: "https://i.imgur.com/cgVu5MP.png",
          url: "https://github.com/t1ra/cryb",
        ),

        thumbnail: Discord::EmbedThumbnail.new(
          url: "https://i.imgur.com/cgVu5MP.png",
        ),

        fields: [
          Discord::EmbedField.new(
            name: "help",
            value: "Show this help",
            inline: true,
          ),
          Discord::EmbedField.new(
            name: "set status [status]",
            value: "Modify my current status",
            inline: true,
          ),
          Discord::EmbedField.new(
            name: "join",
            value: "Join the voice channel you're in",
            inline: true,
          ),
          Discord::EmbedField.new(
            name: "leave",
            value: "Leave the voice channel I'm in.",
            inline: true,
          ),
          Discord::EmbedField.new(
            name: "play [link]",
            value: "Play [link] in whatever channel I'm in. [link] can be any of " \
              "[YouTube, Spotify] [Song, Playlist]."
          )
        ],

        footer: Discord::EmbedFooter.new(
          text: "Created with 🤬 by github.com/t1ra",
        ),

        type: "rich",
        url: nil,
        timestamp: nil,
        image: nil,
      )
      
      BOT.create_message(
        payload.channel_id,
        content: "",
        embed: help_embed
      )
    end
  end
end
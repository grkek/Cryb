require "../logging"
require "./play/*"

module Cryb
  module Play
  
    @@channel_to_join : (Discord::Snowflake | Nil)
    @@current_channel : (Discord::Snowflake | Nil)

    def self.join_message : String
      ["You got it.", "Let's go.", "Aight.", "No problem.", "Joining."].sample
    end

    # Join
    command_base_join = "#{CONFIG.prefix}join"
    BOT.on_message_create do |payload|
      next if payload.author.bot || !payload.content.downcase.starts_with? command_base_join

      guild = BOT.get_channel(payload.channel_id).guild_id
      if guild.nil?
        Logging.error "Failed to join voice channel: get_channel failed."
        next
      end

      channel_to_join(VoiceStates.find_user_voice payload.author.id)
      if @@channel_to_join.nil?
        BOT.create_message payload.channel_id, "You aren't in a channel."
        next
      end

      if channel_to_join.not_nil! == @@current_channel
        BOT.create_message payload.channel_id, "I'm already in the same channel as you."
        next
      end

      BOT.create_message payload.channel_id, join_message
      BOT.voice_state_update guild.to_u64, channel_to_join.not_nil!.to_u64, false, false

      @@current_channel = channel_to_join
    end

    def self.leave_message : String
      ["Cya.", "Bye!", ":(", "I'm out.", "Sure."].sample
    end

    # Leave
    command_base_leave = "#{CONFIG.prefix}leave"
    BOT.on_message_create do |payload|
      next if payload.author.bot || !payload.content.downcase.starts_with? command_base_leave

      guild = BOT.get_channel(payload.channel_id).guild_id
      if guild.nil?
        Logging.error "Failed to join voice channel: get_channel failed."
        next
      end

      if @@current_channel.nil?
        BOT.create_message payload.channel_id, "I ain't in one."
        next
      end
      
      BOT.create_message payload.channel_id, leave_message
      BOT.voice_state_update guild.to_u64, nil, false, false

      @@current_channel = nil
    end
  
    def self.channel_to_join(channel : (Discord::Snowflake | Nil))
      @@channel_to_join = channel
    end

    def self.channel_to_join : (Discord::Snowflake | Nil)
      @@channel_to_join
    end

    def self.playing_message(queue : Int32) : String
      if !queue
        ["Sure.", "Ok.", "I can do that.", "I'll play it now.", "Sure!", "I'm on it."].sample
      ["I'll play that soon.", "Added to the queue.", "Coming up!", "It's in the queue."].sample 
    end

    # Play
    song_queue = [] of String
    command_base_play = "#{CONFIG.prefix}play "
    BOT.on_message_create do |payload|
      next if payload.author.bot || !payload.content.downcase.starts_with? command_base_play

      guild = BOT.get_channel(payload.channel_id).guild_id
      if guild.nil?
        Logging.error "Failed to join voice channel: get_channel failed."
        next
      end

      if @@current_channel.nil?
        BOT.create_message payload.channel_id, "To myself? No thanks."
        next
      end

      songs = payload.split("play ").shift

      songs.each do |song|
        # YouTube
        if song.includes? "youtube.com/playlist"
          # Ask the API for all the songs in the playlist
        elsif song.includes? "youtube.com/watch?" || song.includes? "youtu.be/"
          song_queue.push song
        # Spotify
        elsif song.includes? "open.spotify.com/track/"
          song_queue.push(SpotifyToYouTube.song song)
        elsif song.includes? "open.spotify.com/playlist/"
          song_queue.push(SpotifyToYouTube.playlist song)
        elsif song.includes? "open.spotify.com/album/"
          song_queue.push(SpotifyToYouTube.album song)
        else
          BOT.create_message(payload.channel_id, "Try giving me a link that makes sense.")
        end  
      end

      BOT.create_message(payload.channel_id, playing_message song_queue.size)
    end

  end
end
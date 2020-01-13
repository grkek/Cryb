require "discordcr"

module Cryb
  module Play
    class VoiceStates

      @@voice_states = [] of Discord::VoiceState

      # Keep track of who's where
      BOT.on_guild_create do |payload|
        set_voice_states payload.voice_states
      end

      BOT.on_voice_state_update do |payload|
        update_voice_state payload
      end

      def self.voice_states : Array(Discord::VoiceState)
        @@voice_states
      end
      
      def self.set_voice_states(states : Array(Discord::VoiceState))
        @@voice_states = states
      end

      def self.update_voice_state(state : Discord::VoiceState)
        @@voice_states.each do |voice_state|
          if voice_state.user_id == state.user_id
            @@voice_states.delete voice_state
            @@voice_states.push state
            next
          end
        end
        @@voice_states.push state
      end

      def self.find_user_voice(user_id : Discord::Snowflake) : (Discord::Snowflake | Nil)
        @@voice_states.each do |state|
          if state.user_id == user_id
            return state.channel_id
          end
        end
      end

    end
  end
end
# It's fun!

class MOTD

  @@motds = [
    "Hi MTV, I'm tira, and welcome to my Cryb.",
    "'...'",
    "Overheard at CrybCon: \"cryb.status just blew my mind\".\n\n" \
      "\thttps://github.com/t1ra/cryb",
    "It totally slaps.",
    "'10/10 this bot changed my life.' - A paid^H^H^H^Hfan testimonal",
    "I'm giving up Cogs for this."
  ]

  def self.random : String
    @@motds.sample
  end
end
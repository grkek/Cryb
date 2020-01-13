require "./logging"

require "system/user"
require "yaml"
require "option_parser"

class Config
  include YAML::Serializable

  @[YAML::Field(key: "token")]
  property token : String

  @[YAML::Field(key: "prefix")]
  property prefix : String

  @[YAML::Field(key: "motds")]
  property motds : Bool

  def self.parse : Config
    # TODO: Is this cross-platform?
    file = Path["~", "cryb.yml"].expand(home: true)

    OptionParser.parse! do |parser|
      parser.banner = "Usage: cryb [argumets]"
      parser.on("-h", "--help", "Show this help") do
        puts parser
        exit 0
      end
      parser.on("-c FILE", "--config=FILE", "Set the configuration file location " \
        "(Default: #{file}") { |dir| file = Path.new(dir) }
      parser.on("-m", "--no-motds", "Don't display MOTDs (Default: Off)") { motds = false }
    end

    if !File.exists? file 
      selection = Logging.errorgets "The configuration file #{file} doesn't exist.\n" \
        "Do you want to create one now? [y/N]"
      if selection.nil? || (selection.size == 0 || selection[0].downcase != 'y')
        Logging.warning "Exiting."
        exit 1
      end 

      File.open(file, "w") { |new_config| new_config << generate_config}

      Logging.info "Wrote a new empty config to #{file}. Edit this and start Cryb again."
      exit 0
    end

    Config.from_yaml(File.read(file))
  end

  def self.generate_config
    "token: YOUR-TOKEN-HERE\n" \
    "prefix: 'cryb '\n" \
    "motds: true"
  end
  
end

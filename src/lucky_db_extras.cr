require "avram"
require "habitat"
require "lucky_cli"
require "../tasks/**"

module LuckyDbExtras
  VERSION = "0.1.0"

  Habitat.create do
    setting database : Avram::Database.class
  end
end

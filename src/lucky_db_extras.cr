require "avram"
require "habitat"
require "lucky_cli"
require "tallboy"
require "./lucky_db_extras/**"

module LuckyDbExtras
  VERSION = "0.1.0"

  Habitat.create do
    setting database : Avram::Database.class
  end

  {% begin %}
    {% extras = ["unused_indexes", "extensions", "cache_hit", "all_locks"] %}
    {% for extra in extras %}
      def self.{{ extra.id }} : NamedTuple(column_names: Array(String), rows: Array(Array(String)))?
        LuckyDbExtras.settings.database.run do |db|
          {% class_extra = extra.camelcase(lower: false).id %}
          column_names = [] of String
          rows = [] of Array(String)
          db.query LuckyDbExtras::{{ class_extra }}::SQL do |rs|
            return if rs.column_count.zero?
            # The first row: column names
            rs.column_count.times.each { |i| column_names << rs.column_name(i).as(String) }

            # The result rows
            rs.each do
              rows << rs.column_count.times.map { rs.read.to_s }.to_a
            end
          end
          
          {
            column_names: column_names,
            rows: rows
          }
        end
      end
    {% end %}
  {% end %}
end

require "../tasks/**"

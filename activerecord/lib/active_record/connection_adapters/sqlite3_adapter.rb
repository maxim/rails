require 'active_record/connection_adapters/sqlite_adapter'

module ActiveRecord
  class Base
    # sqlite3 adapter reuses sqlite_connection.
    def self.sqlite3_connection(config) # :nodoc:
      parse_sqlite_config!(config)

      unless self.class.const_defined?(:SQLite3)
        require_library_or_gem(config[:adapter])
      end

      db = SQLite3::Database.new(
        config[:database],
        :results_as_hash => true,
        :type_translation => false
      )

      db.busy_timeout(config[:timeout]) unless config[:timeout].nil?

      ConnectionAdapters::SQLite3Adapter.new(db, logger, config)
    end
  end

  module ConnectionAdapters #:nodoc:
    class SQLite3Adapter < SQLiteAdapter # :nodoc:
      
      # Returns the current database encoding format as a string, eg: 'UTF-8'
      def encoding
        if @connection.respond_to?(:encoding)
          @connection.encoding[0]['encoding']
        else
          encoding = @connection.send(:get_query_pragma, 'encoding')
          encoding[0]['encoding']
        end
      end

    end
  end
end

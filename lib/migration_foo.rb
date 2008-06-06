module ActiveRecord

  class Migration

    MAX_KEY_LENGTH = 64
    OPTION_KEYS = [:restrict, :set_null, :cascade, :no_action]
    OPTION_VALUES = [:on_update, :on_delete]

    class << self

      def add_foreign_key_constraint from_table, to_table, options = {}
        process(from_table, to_table, options) do |ft, tt, id|
          exec "ALTER TABLE #{ft} ADD CONSTRAINT #{id} FOREIGN KEY(#{tt.singularize}_id) REFERENCES #{tt}(id)" << prepare_conditions(options)
        end 
      end
      
      alias_method :add_foreign_key, :add_foreign_key_constraint
      
      def remove_foreign_key_constraint from_table, to_table, options = {}
        process(from_table, to_table, options) do |ft, tt, id|
          exec "ALTER TABLE #{ft} DROP FOREIGN KEY #{id}"
        end
      end

      alias_method :remove_foreign_key, :remove_foreign_key_constraint

      private

      def prepare_conditions options
        conditions = []
        options.each_pair do |key, value|
          conditions << "#{key.to_s.gsub(/_/, ' ')} #{value.to_s.gsub(/_/, ' ')}" if valid_condition?(key, value)
        end
        conditions.join(' ')
      end

      def valid_condition? key, value
        OPTION_VALUES.include?(key.to_sym) && OPTION_KEYS.include?(value.to_sym)
      end

      def process from_table, to_table, options
        id = options[:name] || "fk_#{from_table}_#{to_table}"

        if id.size > MAX_KEY_LENGTH
          id = id.slice(0...MAX_KEY_LENGTH)
          puts %{Warning: foreign key id has more then #{MAX_KEY_LENGTH} characters - sliced to '#{id}'}
        end
        yield from_table.to_s, to_table.to_s, id
      end

      def exec cmd
        execute cmd.gsub(/\t|\n|\r/, ' ').squeeze(' ').strip
      end

    end
  end
end
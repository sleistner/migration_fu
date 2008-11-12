module ActiveRecord

  class Migration

    MAX_KEY_LENGTH = 64
    OPTION_KEYS = [:restrict, :set_null, :cascade, :no_action]
    OPTION_VALUES = [:on_update, :on_delete]

    class << self

      def add_foreign_key(from_table, to_table, options = {})
        process(from_table, to_table, options) do |ft, tt, id|
          execute "ALTER TABLE #{ft} ADD CONSTRAINT #{id} FOREIGN KEY(#{tt.singularize}_id) REFERENCES #{tt}(id)" << conditions(options)
        end 
      end
      
      def remove_foreign_key(from_table, to_table, options = {})
        process(from_table, to_table, options) do |ft, tt, id|
          execute "ALTER TABLE #{ft} DROP FOREIGN KEY #{id}"
        end
      end

      def entirely_reset_column_information
        ActiveRecord::Base.send(:subclasses).each(&:reset_column_information)
      end

      private

      def conditions(options)
        conditions = ''
        options.each_pair do |key, value|
          conditions << " #{key.to_s.gsub(/_/, ' ')} #{value.to_s.gsub(/_/, ' ')}".upcase if condition_valid?(key, value)
        end
        conditions
      end

      def condition_valid?(key, value)
        OPTION_VALUES.include?(key.to_sym) && OPTION_KEYS.include?(value.to_sym)
      end

      def process(from_table, to_table, options)
        id = options[:name] || "fk_#{from_table}_#{to_table}"

        if id.size > MAX_KEY_LENGTH
          id = id.slice(0...MAX_KEY_LENGTH)
          puts "Warning: foreign key id has more then #{MAX_KEY_LENGTH} characters - sliced to '#{id}'"
        end
        yield(from_table.to_s, to_table.to_s, id)
      end
      
    end
  end
end

module ActiveRecord
  
  class Migration

    MAX_KEY_LENGTH = 64
    
    VALID_CONDITION_ARGUMENTS = [:restrict, :set_null, :cascade, :no_action]
    
    VALID_CONDITIONS = [:on_update, :on_delete]
    
    class << self

      def add_foreign_key_constraint(from_table, to_table, options = {})
        process(from_table, to_table, options) do |ft, tt, id|
          exec %{
            alter table #{ft}
            add constraint #{id}
            foreign key(#{tt.singularize}_id)
            references #{tt}(id)
          } << prepare_conditions(options)
        end 
      end
      
      alias_method :add_foreign_key, :add_foreign_key_constraint
      
      def remove_foreign_key_constraint(from_table, to_table, options = {})
        process(from_table, to_table, options) do |ft, tt, id|
          exec "alter table #{ft} drop foreign key #{id}"
        end
      end

      alias_method :remove_foreign_key, :remove_foreign_key_constraint

      private

      def prepare_conditions(options)
        conditions = []
        options.each_pair do |key, value|
          if valid_condition?(key, value)
            conditions << "#{key.to_s.gsub(/_/, ' ')} #{value.to_s.gsub(/_/, ' ')}"
          end
        end
        conditions.join(' ')
      end
      
      def valid_condition?(key, value)
        VALID_CONDITIONS.include?(key.to_sym) && VALID_CONDITION_ARGUMENTS.include?(value.to_sym)
      end
    
      def process(from_table, to_table, options)
        id = options[:name] || "fk_#{from_table}_#{to_table}"
        
        if id.size > MAX_KEY_LENGTH
          id = id.slice(0...MAX_KEY_LENGTH)
          warning %{foreign key id has more then #{MAX_KEY_LENGTH} characters - sliced to '#{id}'}
        end
        yield(from_table.to_s, to_table.to_s, id)
      end
    
      def remove_spaces(string)
        string.gsub(/\t|\n|\r/, ' ').squeeze(' ').strip
      end
    
      def exec(cmd)
        execute remove_spaces(cmd)
      end
      
      def warning(msg)
        puts <<MSG
*************************** warning **********************************
#{msg}
**********************************************************************
MSG
      end
      
    end
  end
end
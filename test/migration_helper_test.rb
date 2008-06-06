require 'test/unit'
require File.dirname(__FILE__) + '/../lib/migration_foo'

class String
  def singularize
    self[0...-1]
  end
end

class ActiveRecord::Migration
  def self.exec(cmd)
    remove_spaces(cmd)
  end
end

class MigrationFooTest < Test::Unit::TestCase
  
  STATEMENT = 'alter table users add constraint fk_users_files foreign key(file_id) references files(id)'

  def setup
    @foo = ActiveRecord::Migration
  end
  
  def test_add_foreign_key_constraint_without_options
    assert_equal STATEMENT, @foo.add_foreign_key_constraint(:users, :files)
  end

  def test_add_foreign_key_constraint_with_invalid_options
    assert_equal STATEMENT, @foo.add_foreign_key_constraint(:users, :files, :on_del => :ca)
  end

  def test_add_foreign_key_constraint_with_valid_options
    assert_equal "#{STATEMENT} on delete cascade", 
      @foo.add_foreign_key_constraint(:users, :files, :on_delete => :cascade)
    assert_equal "#{STATEMENT} on delete cascade on update set null", 
      @foo.add_foreign_key_constraint(:users, :files, :on_delete => :cascade, :on_update => :set_null)
  end
  
  def test_with_name
    assert_equal 'alter table users add constraint fk_my_name foreign key(file_id) references files(id)',
      @foo.add_foreign_key_constraint(:users, :files, :name => 'fk_my_name')
  end
  
end
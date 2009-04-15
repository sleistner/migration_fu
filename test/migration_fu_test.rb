require 'test/unit'
require File.dirname(__FILE__) + '/../lib/migration_fu'

class String
  def singularize; self[0...-1] end
end

class ActiveRecord::Migration
  def self.execute command; command end
end

class MigrationFuTest < Test::Unit::TestCase
  
  ID        = 'fk_users_files'
  CUSTOM_ID = 'fk_my_name'
  
  def setup
    @foo = ActiveRecord::Migration
  end
  
  def test_should_add_foreign_key_without_options
    assert_equal add_command, add
  end

  def test_should_add_foreign_key_with_invalid_options_but_ignore_them
    assert_equal add_command, add(:on_del => :ca)
  end

  def test_should_add_foreign_key_with_valid_options
    assert_equal "#{add_command} ON DELETE CASCADE", add(:on_delete => :cascade)
    assert_equal "#{add_command} ON DELETE CASCADE ON UPDATE SET NULL", add(:on_update => :set_null, :on_delete => :cascade)
  end
  
  def test_should_add_foreign_key_with_optional_name
    assert_equal add_command(CUSTOM_ID), add(:name => CUSTOM_ID)
  end
  
  def test_should_add_foreign_key_and_truncate_id
    to = 'x' * 70
    assert_equal add_command('fk_users_' << 'x' * 55, to), @foo.add_foreign_key(:users, to.to_sym)
  end
  
  def test_should_remove_foreign_key
    assert_equal remove_command, remove
  end
  
  def test_should_remove_foreign_key_with_optional_name
    assert_equal remove_command(CUSTOM_ID), remove(:name => CUSTOM_ID)
  end
  
  private
  
  def add(options = {})
    @foo.add_foreign_key :users, :files, options
  end

  def remove(options = {})
    @foo.remove_foreign_key :users, :files, options
  end
  
  def add_command(id = ID, to = 'files')
    "ALTER TABLE users ADD CONSTRAINT #{id} FOREIGN KEY(#{to.singularize}_id) REFERENCES #{to}(id)"
  end
  
  def remove_command(id = ID)
    "ALTER TABLE users DROP FOREIGN KEY #{id}"
  end
  
end
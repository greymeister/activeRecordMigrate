class CreatePerson < ActiveRecord::Migration
  def self.up
    create_table :person, {:id => true} do |inst|
      inst.column :name, :string, :limit => 100, :null => false
      inst.column :url, :string, :null => false
      inst.column :lock_version, :integer, { :default => 0 }
    end
  end

  def self.down
    drop_table :person
  end
end

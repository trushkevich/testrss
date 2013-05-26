class AddProfileTypeToUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def up
    change_table :users do |t|
      t.string :profile_type, :default => 'basic', :null => false
    end
    User.reset_column_information
    User.update_all ["profile_type = ?", 'basic']
  end

  def down
    remove_column :users, :profile_type
  end
end

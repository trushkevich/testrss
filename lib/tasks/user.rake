namespace :users do

  task :set_admin, [:id] => [:environment] do |task, args|
    if user = User.find_by_id(args[:id])
      user.update_attributes(is_admin: true)
      puts "User with id #{id} successfully set to be admin"
    else
      puts "Could not find a user with id #{id}"
    end
  end

  task :unset_admin, [:id] => [:environment] do |task, args|
    if user = User.find_by_id(args[:id])
      user.update_attributes(is_admin: false)
      puts "User with id #{id} successfully unset from being admin"
    else
      puts "Could not find a user with id #{id}"
    end
  end

end
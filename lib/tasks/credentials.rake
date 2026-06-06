namespace :credentials do
  desc 'Edit Rails credentials in Cursor. Usage: bin/rails "credentials:edit_with_cursor[production]"'
  task :edit_with_cursor, [ :environment_name ] do |_task, args|
    command = [ Rails.root.join("bin/rails").to_s, "credentials:edit" ]
    command += [ "--environment", args[:environment_name] ] if args[:environment_name].present?

    success = system({ "EDITOR" => "cursor --wait" }, *command)
    abort "Failed to edit Rails credentials with Cursor" unless success
  end
end

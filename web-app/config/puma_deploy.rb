workers 2
threads 1, 6
app_dir = File.expand_path("../..", __FILE__)
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env
bind "tcp://0.0.0.0:3000"
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end

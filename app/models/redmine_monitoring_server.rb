class RedmineMonitoringServer < ActiveRecord::Base
  unloadable
  self.abstract_class = true
  database_redmine_monitoring_server = YAML::load(File.open('plugins/redmine_monitoring_server/config/database_redmine_monitoring_server.yml') )
  
  establish_connection( database_redmine_monitoring_server[ (ENV["RAILS_ENV"] || "production") ] )
end

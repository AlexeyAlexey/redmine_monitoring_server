


ActionDispatch::Callbacks.to_prepare do
  Rails.logger.info 'Starting Redmine Monitoring Server plugin'

  db_connection_list = YAML::load(File.open('plugins/redmine_monitoring_server/config/database_redmine_monitoring_server.yml') ).keys

  db_connection_list.each do |class_name|
    database_redmine_monitoring_server = YAML::load(File.open('plugins/redmine_monitoring_server/config/database_redmine_monitoring_server.yml') )[class_name]
    cl = Object.const_set((class_name + "_monitoring_server").classify, Class.new(ActiveRecord::Base){self.abstract_class = true} )
    cl.establish_connection( database_redmine_monitoring_server )
  end

  #Project.send(:include, MonitoringServer::ProjectPatch)
end
Redmine::Plugin.register :redmine_monitoring_server do
  name 'Redmine Monitoring Server plugin'
  author 'Alexey Kondratenko'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :monitoring_server do
    permission :monitoring_server_results, { :monitoring_server_results => [:index]}
  end

  menu :project_menu, :monitoring_server_results, { :controller => 'monitoring_server_results', :action => 'index' }, :caption => 'Monitoring Server Results'

  settings :default => {'empty' => true}, :partial => 'settings/monitoring_server_settings'

  Redmine::MenuManager.map :monitoring_server_settings_menu do |menu|
    menu.push :monitoring_server_settings, { :controller => 'monitoring_server_settings', :action => 'index'}, {}
    menu.push :new, { :controller => 'monitoring_server_settings', :action => 'new'}, {}
  end
end

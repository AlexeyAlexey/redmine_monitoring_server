ActionDispatch::Callbacks.to_prepare do
  Rails.logger.info 'Starting Redmine Monitoring Server plugin'

  Project.send(:include, MonitoringServer::ProjectPatch)
end
Redmine::Plugin.register :redmine_monitoring_server do
  name 'Redmine Monitoring Server plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :monitoring_server do
    permission :monitoring_results, { :monitoring_results => [:index]}
  end

  menu :project_menu, :monitoring_results, { :controller => 'monitoring_results', :action => 'index' }, :caption => 'Monitoring Results'
end

class MonitoringServerAbstractionModel
  unloadable
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include MonitoringModelQueryMethodsHelper
   
  
  DB_CONNECTION_NAMES_LIST = YAML::load(File.open('plugins/redmine_monitoring_server/config/database_redmine_monitoring_server.yml') ).keys

  DB_CONNECTIONS_LIST = Hash[ *(DB_CONNECTION_NAMES_LIST.map{|name| [name, Object.const_get("#{name}_#{"monitoring_server"}".classify) ]}.flatten) ]

end
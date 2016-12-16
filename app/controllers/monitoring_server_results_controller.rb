class MonitoringServerResultsController < ApplicationController
  unloadable
  helper MonitoringServerResultsHelper
  
  before_filter :require_login
  #before_filter :find_project_by_project_id
  before_filter :find_project
  before_filter :authorize


  def index
    #@project => "monitoring_results_#{postfix}"
    #RedmineMonitoringServer
  	#@monitoring = @project.monitoring_results.first
    
    #table_name = RedmineMonitoringServer.connection.quote_table_name("monitoring_results")

    #db_request = RedmineMonitoringServer.connection.exec_query("select * from monitoring_results where project_id='#{@project.id}' LIMIT 1")
    #initialize(db_connection, table_name, columns = [])   
    db_connection = MonitoringServerAbstractionModel::DB_CONNECTIONS_LIST["redmine_clear_development"]
    @monitoring = MonitoringServerAbstractionModel.new(db_connection, "monitoring_results")

    #@monitoring = MonitoringServerResult.new("monitoring_results")
    #@monitoring.where(" project_id = ? ", 1)
    #@monitoring.limit(1)
    #@monitoring = @monitoring.exec_query.first

    #@controllers_list = @monitoring.result.keys
    
    #@controllers_list.delete_if{|el| ["controllers", "severity"].include?(el)}

  end

  def build_filter_form

  end

  def destroy
  end
end

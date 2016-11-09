class MonitoringResultsController < ApplicationController
  unloadable
  helper MonitoringResultsHelper
  
  before_filter :require_login
  #before_filter :find_project_by_project_id
  before_filter :find_project
  before_filter :authorize


  def index
  	@monitoring = @project.monitoring_results.first
    
    @controllers_list = @monitoring.result.keys
    @controllers_list.delete_at(0)
    @controllers_list.delete_at(0)

  end

  def destroy
  end
end

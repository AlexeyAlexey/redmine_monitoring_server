class MonitoringResultsController < ApplicationController
  unloadable
  before_filter :require_login
  #before_filter :find_project_by_project_id
  before_filter :find_project
  before_filter :authorize


  def index
  	@monitoring_result = @project.monitoring_results.first

  end

  def destroy
  end
end

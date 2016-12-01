class MonitoringServerResult
  unloadable
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  include MonitoringModelQueryMethodsHelper

  #attr_accessor :id, :project_id, :server_id, :monitoring_day, :created_at, :updated_at, :table_name
  #attr_accessor :request, :request_res, :records
  
  
  def result=(str)
    @result = JSON.parse(str)
    @result
  end 
  def result
    @result
  end

end
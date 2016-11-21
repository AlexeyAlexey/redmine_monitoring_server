class MonitoringResult
  unloadable
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id, :project_id, :server_id, :monitoring_day, :created_at, :updated_at, :table_name

  def initialize(table_name, request_res)
  	rows = request_res.rows[0]
  	
  	request_res.columns.each_with_index do |column_name, index|
      self.send("#{column_name}=", rows[index])
  	end
  	
  	@table_name = table_name
  	
  end
  
  def result=(str)
    @result = JSON.parse(str)
    @result
  end 
  def result
    @result
  end
end
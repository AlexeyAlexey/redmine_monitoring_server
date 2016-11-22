class MonitoringResult
  unloadable
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id, :project_id, :server_id, :monitoring_day, :created_at, :updated_at, :table_name
  attr_accessor :request, :request_res, :records


  def initialize(table_name)  	
  	@table_name = table_name
    @select = ["SELECT ", "* "]
    @request = []
    @records = []
  end
  
  def result=(str)
    @result = JSON.parse(str)
    @result
  end 
  def result
    @result
  end
  
  def each(&block)
    @records.each(&block)
  end
  def map(&block)
    @records.map(&block)
  end
  def first
    @records.first
  end

#query methods
  def select(columns)
    @select[1] = columns.map{|column| quote_column_name(column)}.join(', ')
    self
  end

  def where(str, *args)
    args.each do |value|
      str = str.sub(/\?/, "'#{quote(value)}'")
    end
    @request.empty? ? @request << str : @request << " AND #{str} "
      
    self
  end

  def or(str, *args)
    args.each do |value|
      str = str.sub(/\?/, "'#{quote(value)}'")
    end
    @request.empty? ? @request << str : @request << " OR #{str} "
      
    self
  end

  def limit(value)
    if value.is_a?(Integer)
      @request << " LIMIT #{value} "
    end
    self
  end

  def all 
    @request << " "
    self
  end

  def to_query
    if @request.empty?
      "SELECT * FROM #{quote_table_name(@table_name)}"
    else
      "SELECT * FROM #{quote_table_name(@table_name)} WHERE " + @request.join(' ')
    end
  end

  def exec_query
    @request_res = RedmineMonitoringServer.connection.exec_query(to_query)
    rows = @request_res.rows
    
    rows.each do |row|
      @records << build_record(row)
    end
    
    @records
  end

  def build_record(row)
    new_record = MonitoringResult.new(table_name)
    @request_res.columns.each_with_index do |column_name, index|
      new_record.send("#{column_name}=", row[index])
    end
    new_record
  end

  def quote(value)
    RedmineMonitoringServer.connection.quote(value)
  end

  def quote_table_name(table_name)
    RedmineMonitoringServer.connection.quote_table_name(table_name)
  end

  def quote_column_name(column_name)
    RedmineMonitoringServer.connection.quote_column_name(column_name)
  end
end
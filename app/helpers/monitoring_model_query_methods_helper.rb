module MonitoringModelQueryMethodsHelper

  
  def initialize(table_name, columns = [])  	
  	@table_name = table_name
    @select = ["SELECT ", "* "]
    @request = []
    @records = []
    @columns = columns

    unless @columns.empty?
      build_fields
    end
  end

  def table_name
    @table_name
  end
  def table_name=(table_name)
    @table_name = table_name
  end
  def columns
    @columns
  end
  def columns=(columns)
    @columns = columns
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

    @columns = @request_res.columns
    build_fields

    rows.each do |row|
      @records << build_record(row)
    end
    
    @records
  end

  def build_record(row)
    new_record = self.class.new(table_name, @columns)

    @request_res.columns.each_with_index do |column_name, index|
      new_record.send("#{column_name}=", row[index])
    end
    new_record
  end
  def create_method(name, &block)
    self.class.send(:define_method, name, &block)
  end
  def build_fields
  	@columns.each do |field|
  	  unless self.respond_to?(field)
        create_method("#{field}=") do |value|
          instance_variable_set("@#{field}", value)
        end
        create_method("#{field}") do
          instance_variable_get("@#{field}")
        end
      end
    end

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
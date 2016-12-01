module MonitoringModelQueryMethodsHelper

  
  def initialize(db_connection, table_name, columns = [])  	
  	@table_name = table_name

    @select = []
    @request = []
    @records = []
    @columns = columns

    @where = []
    
    @query = []

    @db_connection = db_connection
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
  def select(columns = [])
    select = []
    if columns.empty?
      select << "#{quote_table_name(@table)}.*"
    else
      columns.map{|table| select << "#{quote_table_name(@table)}.#{columns}"}
    end
    select = "SELECT " + select.jon(', ')
    @query << select
    
    self
  end

  def from(table_name=nil)
    table_name ||= @table_name
    @query << " FROM #{quote_table_name(table_name)}} "
  end

  def where(table_name=nil, columns, unions, values)
    table_name ||= @table_name

    where = [" WHERE "]
    where << columns.map do |column|
      "#{quote_table_name(table_name)}.#{quote_column_name(column)} = ?"
    end
    str = where.join(" #{filter_unions(unions)} ")
    
    values.each do |value|
      str = str.sub(/\?/, "'#{quote(value)}'")
    end

    @query << str

    self
  end
  def filter_unions(unions)
    unions.reject{|union| ["AND", "OR", "and", "or"].include?(union)}
  end

  

  def where_without_union(str, *args)
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
    @request_res = @db_connection.connection.exec_query(to_query)
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
    @db_connection.connection.quote(value)
  end

  def quote_table_name(table_name)
    @db_connection.connection.quote_table_name(table_name)
  end

  def quote_column_name(column_name)
    @db_connection.connection.quote_column_name(column_name)
  end




end
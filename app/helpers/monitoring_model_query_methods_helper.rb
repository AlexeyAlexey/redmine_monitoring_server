module MonitoringModelQueryMethodsHelper

  
  def initialize(db_connection, table_name, columns = [])  	
  	@table_name = table_name

    @select = {}
    @from   = {}
    @where  = {}
    @left_join = {}
    @join_tables = {}
    @on     = {}

    @request = []
    @records = []
    @columns = columns

    
    
    #@query = []
    
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
  def request
    @request
  end
  def request=(request)
    @request = request
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
  def db_connection
    @db_connection
  end
  def db_connection=(db_connection)
    @db_connection = db_connection
  end
  def records
    @records
  end
#query methods
  def select(columns = [])
    select = []
    if columns.empty?
      select << "#{quote_table_name(@table_name)}.*"
    else
      columns.map{|table| select << "#{quote_table_name(@table_name)}.#{columns}"}
    end
    select = "SELECT " + select.join(', ')

    @request.push select

    @select[@request.size - 1] = {request: select}

    self
  end
  def select_h
    @select
  end

  def from(table_name=nil)
    table_name ||= @table_name
    from_str = " FROM #{quote_table_name(table_name)} "
    
    @request.push from_str

    @from[@request.size - 1] = {request: from_str} 

    self
  end
  def from_h
    @from    
  end

  def where(table_name=nil, columns, inequalities, unions, values)
    table_name ||= @table_name

    where = []
    where << columns.map do |column|
      "#{quote_table_name(table_name)}.#{quote_column_name(column)} __inequalities__ ? "
    end
    where_str = where.join(" __union__ ")
    
    inequalities.each do |inequality|
      where_str = where_str.sub(/__inequalities__/, "#{filter_inequalities(inequalities, inequality)}")
    end
    unions.each do |union|
      where_str = where_str.sub(/__union__/, "#{filter_unions(unions, union)}")
    end

    values.each do |value|
      where_str = where_str.sub(/\?/, "#{quote(value)}")
    end
    
    where_str = " WHERE " + where_str
    @request.push where_str
    
    @where[@request.size - 1] = {request: where_str}

    self
  end
  def where_h
    @where
  end
  def filter_unions(unions, union)
    unions.find{|union| ["AND", "OR"].include?(union.upcase)}
  end
  def filter_inequalities(inequalities, inequality)
    inequalities.find{|union| ["=", ">", "<", "<>"].include?(inequality)}
  end

  #LEFT JOIN table2 ON table1.id=table2.id
  def left_join(join_table_name)
    left_join = " LEFT JOIN #{quote_table_name(join_table_name)} "

        

    @request.push left_join

    @join_tables[@request.size - 1] = {table_name: join_table_name}
    @left_join[@request.size - 1] = {request: left_join}

    self
  end
  def on(join_table, join_columns)
    on = "ON #{quote_table_name(@table_name)}.#{quote_column_name(join_columns[0])} = #{quote_table_name(join_table)}.#{quote_column_name(join_columns[1])}"
  
    @on[@request.size - 1] = {request: on}

    @request.push on
  end

  def where_without_union(str, *args)

    args.each do |value|
      str = str.sub(/\?/, "#{quote(value)}")
    end
    @request << (" WHERE " + str)
      
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
      @request.join(' ')
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
    new_record = self.class.new(db_connection, @table_name, @columns)

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
require File.expand_path('../../test_helper', __FILE__)

class MonitoringServerAbstractionModelTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  #rake test TEST=plugins/redmine_monitoring_server/test/unit/monitoring_server_abstraction_model_test.rb
  #TESTOPTS="--name=test_truth -v" 
  def test_connections_list
    MonitoringServerAbstractionModel::DB_CONNECTIONS_LIST.each do |key, value|
      assert value.ancestors.include?(ActiveRecord::Base)
    end
  end

  def test_query_value
  	issue = Issue.first
    db_connection = MonitoringServerAbstractionModel::DB_CONNECTIONS_LIST["test"]
    monitoring = MonitoringServerAbstractionModel.new(db_connection, "issues")
    monitoring.select
    monitoring.from
    monitoring.where(["id", "tracker_id", "subject"], ["=", "=", "="], ["AND", "OR"], [issue.id, issue.tracker_id, issue.subject])
    monitoring.limit(1)

    monitoring.exec_query

    record = monitoring.records.first

    assert monitoring.records.size == 1
    assert record.id == issue.id and record.tracker_id == issue.tracker_id and record.subject == issue.subject
    #initialize(db_connection, table_name, columns = [])   
  end

  def test_record_columns
  	issue = Issue.first
    db_connection = MonitoringServerAbstractionModel::DB_CONNECTIONS_LIST["test"]

    monitoring = MonitoringServerAbstractionModel.new(db_connection, "issues")
    monitoring.select
    monitoring.from
    monitoring.where(["id", "tracker_id", "subject"], ["=", "=", "="], ["AND", "OR"], [issue.id, issue.tracker_id, issue.subject])
    monitoring.limit(1)

    monitoring.exec_query
    
    assert monitoring.first.columns == Issue.column_names
  end

  def test_left_join
  	issue = Issue.first
    db_connection = MonitoringServerAbstractionModel::DB_CONNECTIONS_LIST["test"]

    monitoring = MonitoringServerAbstractionModel.new(db_connection, "issues")
    monitoring.select
    monitoring.from
    
    monitoring.left_join("trackers")
    monitoring.on("trackers", ["tracker_id", "id"])

    monitoring.where(["tracker_id"], ["<>"], [], [issue.tracker_id])
    
    monitoring.exec_query
  	
  	assert monitoring.first.tracker_id != issue.tracker_id
  end

  #monitoring.request[2] == monitoring.instance_variable_get(:@where)[2][:request]
end


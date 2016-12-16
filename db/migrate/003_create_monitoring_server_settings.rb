class CreateMonitoringServerSettings < ActiveRecord::Migration
  def change
    create_table :monitoring_server_settings do |t|
      t.integer :project_id
      t.string :db_connection_name
      t.string :tables_list
      t.string :join_settings
    end
  end
end

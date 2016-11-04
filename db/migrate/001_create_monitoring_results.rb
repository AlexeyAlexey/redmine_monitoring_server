class CreateMonitoringResults < ActiveRecord::Migration
  def change
    create_table :monitoring_results do |t|
      t.integer  :project_id, null: false
      t.integer  :server_id,  null: false
      t.datetime :monitoring_day,  null: false
      t.text     :result, default: ""

      t.timestamps null: false
    end
    add_index :monitoring_results, [:project_id]
    add_index :monitoring_results, [:server_id]
  end
end

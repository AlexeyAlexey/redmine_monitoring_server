class CreateMonitoringResults < ActiveRecord::Migration
  def change(postfix)
    create_table "monitoring_results_#{postfix}" do |t|
      t.integer  :project_id, null: false
      t.integer  :server_id,  null: false
      t.datetime :monitoring_day,  null: false
      t.text     :result, default: ""

      t.timestamps null: false
    end
    add_index "monitoring_results_#{postfix}", [:project_id]
    add_index "monitoring_results_#{postfix}", [:server_id]
  end

  def down(postfix)
    drop_table "monitoring_results_#{postfix}"
  end
end

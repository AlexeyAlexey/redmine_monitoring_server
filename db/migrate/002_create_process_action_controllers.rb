class CreateProcessActionControllers < ActiveRecord::Migration
  def change(postfix)
    create_table "process_action_controller_#{postfix}", :options => 'DEFAULT CHARSET=utf8' do |t|
      t.text     :process,      limit: 2147483647
      t.datetime :time
      t.string   :transaction_id
      t.datetime :end_time
      t.float    :duration
      t.datetime :timestamp
      t.integer  :version
      t.string  :severity
      t.string  :controller
      t.string  :action
      t.integer :status,       limit: 2, default: 0
      t.text    :params
      t.string  :format
      t.string  :method
      t.text    :path
      t.float   :view_runtime
      t.float   :db_runtime
      t.string  :ip
      t.integer :user_id
      t.string  :session_id
      t.string  :http_user_agent
      t.text    :headers
      t.text    :request_from_page
      t.string  :request_unique_id
    end
    add_index "process_action_controller_#{postfix}", [:request_unique_id]
  end

  def down(postfix)
    drop_table "process_action_controller_#{postfix}"
  end
end
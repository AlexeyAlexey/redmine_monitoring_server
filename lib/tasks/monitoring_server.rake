namespace :monitoring_server do
  desc "Apply db tasks in custom databases, for example  rake monitoring_server:alter[redmine:plugins:migrate,test-es] applies db:migrate on the database defined as test-es in databases.yml"
  #"Apply db tasks in custom databases, for example  rake monitoring_server:alter[db:migrate,test-es] applies db:migrate on the database defined as test-es in databases.yml"
  task :alter, [:task, :database] => [:environment] do |t, args|
    #ENV["RAILS_ENV"]
  	byebug
  	#args.task => "db:migrate"
  	#args.database => "test-es"
    #require 'activerecord'
    #puts "Applying #{args.task} on #{args.database}"
    #ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[args.database])

    #NAME = monitoring_server
    #Rake::Task[args.task].invoke

    #rake redmine:plugins:migrate NAME=monitoring_server
  end

  task :db_add_tables => :environment do
    postfix = ENV["postfix"]

    create_mon_res = CreateMonitoringResults.new
    create_mon_res.change("action_controller_#{postfix}")
    create_mon_res.change("logfile_#{postfix}")

  end

  task :db_delete_tables => :environment do
    postfix = ENV["postfix"]

    create_mon_res = CreateMonitoringResults.new
    create_mon_res.down("action_controller_#{postfix}")
  end
end
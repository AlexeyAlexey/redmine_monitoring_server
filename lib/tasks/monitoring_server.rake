namespace :monitoring_server do
  desc "Apply db tasks in custom databases, for example  rake monitoring_server:alter[redmine:plugins:migrate,test-es] applies db:migrate on the database defined as test-es in databases.yml"
  #"Apply db tasks in custom databases, for example  rake monitoring_server:alter[db:migrate,test-es] applies db:migrate on the database defined as test-es in databases.yml"
  task :alter, [:task, :database] => [:environment] do |t, args|
    #require 'activerecord'
    #ENV["RAILS_ENV"]
    
  	#args.task => "db:migrate"
  	#args.database => "test-es"
    
    #puts "Applying #{args.task} on #{args.database}"
    

    #NAME = monitoring_server
    #Rake::Task[args.task].invoke

    #rake redmine:plugins:migrate NAME=monitoring_server
  end
  
  namespace :migrate do
    namespace :plugin do
      #RAILS_ENV=production rake monitoring_server:migrate:plugin:up
      task :up => :environment do
        rails_env = ENV["RAILS_ENV"] || "production"
        ActiveRecord::Base.establish_connection( ActiveRecord::Base.configurations[rails_env] )
        #load 'plugins/redmine_monitoring_server/db/migrate/001_create_monitoring_results.rb'
      end
      #RAILS_ENV=production rake monitoring_server:migrate:plugin:down
      task :down => :environment do
        rails_env = ENV["RAILS_ENV"] || "production"
        ActiveRecord::Base.establish_connection( ActiveRecord::Base.configurations[rails_env] )
        #load 'plugins/redmine_monitoring_server/db/migrate/001_create_monitoring_results.rb'
      end
    end
    #RAILS_ENV=development rake monitoring_server:migrate:add_tables postfix=1
    task :add_tables => :environment do
      #require 'activerecord'
      load 'plugins/redmine_monitoring_server/db/migrate/001_create_monitoring_results.rb'
      
      rails_env = ENV["RAILS_ENV"] || "production"
      postfix   = ENV["postfix"]
      
      database_redmine_monitoring_server = YAML::load(File.open('plugins/redmine_monitoring_server/config/database_redmine_monitoring_server.yml') )
      unless postfix.nil?
        create_mon_res = CreateMonitoringResults.new
        create_mon_res.change(postfix)
        #create_mon_res.change("logfile_#{postfix}")
      else 
        puts "postfix is nil"
      end
    end
    #RAILS_ENV=development rake monitoring_server:migrate:delete_tables postfix=1
    task :delete_tables => :environment do
      load 'plugins/redmine_monitoring_server/db/migrate/001_create_monitoring_results.rb'
      postfix = ENV["postfix"]
      unless postfix.nil?
        create_mon_res = CreateMonitoringResults.new
        create_mon_res.down("postfix")
      else
        puts "postfix is nil"
      end
    end

  end#namespace :migrate do
end
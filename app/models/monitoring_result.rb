class MonitoringResult < ActiveRecord::Base
  unloadable
  belongs_to :project
  
  serialize :result, JSON
end

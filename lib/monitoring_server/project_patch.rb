module MonitoringServer
  module ProjectPatch
	module ClassMethods
	end
	
	module InstanceMethods
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
		receiver.class_eval do
    	  unloadable # Send unloadable so it will not be unloaded in development
          has_many :monitoring_results
  	  end
	end
  end
end
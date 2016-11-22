class MonitoringAbstractionModel
  unloadable
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include MonitoringModelQueryMethodsHelper


end
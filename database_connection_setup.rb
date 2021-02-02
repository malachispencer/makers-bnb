require_relative './lib/database_connection'

if ENV['ENVIRONMENT'] == 'test'
  DatabaseConnection.setup(dbname: 'makers_bnb_test')
elsif ENV['ENVIRONMENT'] == 'development'
  DatabaseConnection.setup(dbname: 'makers_bnb')
else
  DatabaseConnection.production_setup
end

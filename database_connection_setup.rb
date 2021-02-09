require_relative './lib/database_connection'

if ENV['ENVIRONMENT'] == 'test'
  DatabaseConnection.setup(dbname: 'makers_bnb_test')
elsif ENV['ENVIRONMENT'] == 'production'
  DatabaseConnection.production_setup
else
  DatabaseConnection.setup(dbname: 'makers_bnb')
end

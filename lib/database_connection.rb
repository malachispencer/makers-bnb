#require 'uri'
require 'pg'

class DatabaseConnection
  def self.setup(dbname:)
    p 'IN DATABASE CONNECTION >>>>>>>>>>>>>>>>>>>'
    p dbname
    
    @connection = PG.connect(dbname: dbname)
    p @connection
  end

  def self.production_setup
    p 'IN PRODUCTION SETUP >>>>>>>>>>>>'

    db_url = ENV['DATABASE_URL']

    p db_url

    uri = URI.parse(db_url)

    p uri.hostname
    p uri.port
    p uri.user
    p uri.password
    p uri.path

    @connection = PG.connect(
      dbname: db_url
    )
  end

  def self.query(sql)
    @connection.exec(sql)
  end
end

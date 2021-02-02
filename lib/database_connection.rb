# frozen_string_literal: true

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
    p 'DB URL IS ABOVE >>>>>>>>>>>>>>'
    @connection = PG.connect(
      dbname: db_url
    )
  end

  def self.query(sql)
    @connection.exec(sql)
  end
end

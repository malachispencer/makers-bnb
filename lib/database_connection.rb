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

    host = ENV['DATABASE_HOST']
    database = ENV['DATABASE_NAME']
    username = ENV['DATABASE_USER']
    password = ENV['DATABASE_PASSWORD']

    @connection = PG.connect(
      user: username,
      password: password,
      dbname: database,
      host: host
    )
  end

  def self.query(sql)
    @connection.exec(sql)
  end
end

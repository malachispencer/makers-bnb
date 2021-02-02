# frozen_string_literal: true

require 'pg'

class DatabaseConnection
  def self.setup(dbname:)
    p 'IN DATABASE CONNECTION >>>>>>>>>>>>>>>>>>>'
    p dbname
    
    @connection = PG.connect(dbname: dbname)
    p @connection
  end

  def self.query(sql)
    @connection.exec(sql)
  end
end

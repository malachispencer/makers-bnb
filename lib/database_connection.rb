require 'pg'

class DatabaseConnection
  def self.setup(dbname:)
    @connection = PG.connect(dbname: dbname)
  end

  def self.production_setup
    p 'IN PRODUCTION SETUP >>>>>>>>>>>>'

    db_url = ENV['DATABASE_URL']
    uri = URI.parse(db_url)

    host = uri.hostname
    port = uri.port
    db_name = uri.path[1..-1]
    user = uri.user
    password = uri.password

    @connection = PG.connect(
      host: host,
      port: port,
      dbname: db_name,
      user: user,
      password: password
    )
  end

  def self.query(sql)
    @connection.exec(sql)
  end
end

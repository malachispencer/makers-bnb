require 'bcrypt'
require_relative './database_connection'

class User
  attr_reader :id, :name, :email

  def initialize(id:, name:, email:)
    @id = id
    @name = name
    @email = email
  end

  def self.create(name:, email:, password:)
    encrypted_password = BCrypt::Password.create(password)
    email = email.downcase

    result = DatabaseConnection.query(
      "INSERT INTO users (name, email, password)
      VALUES ('#{name}', '#{email}', '#{encrypted_password}')
      RETURNING id, name, email;"
    ).first

    User.new(
      id: result['id'], 
      name: result['name'], 
      email: result['email']
    )
  end

  def self.find(id:)
    return nil unless id

    result = DatabaseConnection.query(
      "SELECT * FROM users
      WHERE id = '#{id}';"
    ).first

    User.new(
      id: result['id'], 
      name: result['name'], 
      email: result['email']
    )
  end

  def self.find_by_email(email:)
    email = email.downcase

    result = DatabaseConnection.query(
      "SELECT * FROM users WHERE email = '#{email}';"
    ).first

    return nil if !result

    User.new(
      id: result['id'],
      name: result['name'],
      email: result['email']
    )
  end

  def self.authenticate(email:, password:)
    result = DatabaseConnection.query(
      "SELECT * FROM users
      WHERE email = '#{email.downcase}';"
    ).first

    return nil unless result
    return nil unless BCrypt::Password.new(result['password']) == password

    User.new(
      id: result['id'], 
      name: result['name'], 
      email: result['email']
    )
  end
end

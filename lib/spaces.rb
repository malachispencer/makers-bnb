class Space
  attr_reader :id, :name, :description, :location, :price, :user_id

  def initialize(id, name, description, location, price, user_id)
    @id = id
    @name = name
    @description = description
    @location = location
    @price = price.to_i
    @user_id = user_id
  end

  def self.create(name:, description:, location:, price:, user_id:)
    name = escape_apostrophes(name)
    description = escape_apostrophes(description)
    location = escape_apostrophes(location)

    result = DatabaseConnection.query(
      "INSERT INTO spaces 
      (name, description, location, price, user_id)
      VALUES ('#{name}', '#{description}', '#{location}', #{price}, '#{user_id}')
      RETURNING id, name, description, location, price, user_id;"
    ).first

    Space.new(
      result['id'],
      result['name'],
      result['description'],
      result['location'],
      result['price'],
      result['user_id']
    )
  end

  def self.all
    sql = "
      SELECT s.id, s.name, 
      s.description, s.location, 
      s.price, s.user_id, 
      u.name AS host_name
      FROM spaces AS s
      INNER JOIN users AS u
      ON s.user_id = u.id
      ORDER BY s.id DESC;
    "
    results = DatabaseConnection.query(sql)

    results.map do |result|
      space = Space.new(
        result['id'], 
        result['name'], 
        result['description'], 
        result['location'], 
        result['price'], 
        result['user_id']
      )

      { space: space, host_name: result['host_name'] }
    end
  end

  def self.retrieve_available(user_id:, date:)
    sql = "
      SELECT s.id, s.name, 
      s.description, s.location, 
      s.price, s.user_id, 
      u.name AS host_name
      FROM spaces AS s
      INNER JOIN users AS u
      ON s.user_id = u.id
      WHERE s.user_id != '#{user_id}'
      AND s.id NOT IN (
        SELECT space_id
        FROM bookings
        WHERE (check_in = '#{date}' AND booked = TRUE)
        OR (
          check_in = '#{date}' 
          AND booked = FALSE 
          AND user_id = '#{user_id}'
        )
      );
    "
    results = DatabaseConnection.query(sql)

    results.map do |result|
      space = Space.new(
        result['id'], 
        result['name'], 
        result['description'], 
        result['location'], 
        result['price'], 
        result['user_id']
      )

      { space: space, host_name: result['host_name'] }
    end
  end

  def self.find_by_id(id:)
    result = DatabaseConnection.query(
      "SELECT * FROM spaces WHERE id = '#{id}';"
    ).first

    Space.new(
      result['id'],
      result['name'],
      result['description'],
      result['location'],
      result['price'],
      result['user_id']
    )
  end

  def self.all_by_user_id(user_id:)
    spaces = DatabaseConnection.query(
      "SELECT * 
      FROM spaces 
      WHERE user_id = '#{user_id}' 
      ORDER BY id DESC;"
    )

    spaces.map do |space|
      Space.new(
        space['id'],
        space['name'],
        space['description'],
        space['location'],
        space['price'],
        space['user_id']
      )
    end
  end

  def self.update(space_id:, name:, description:, location:, price:)
    name = escape_apostrophes(name)
    description = escape_apostrophes(description)
    location = escape_apostrophes(location)

    space = DatabaseConnection.query(
      "UPDATE spaces
      SET name = '#{name}', 
      description = '#{description}', 
      location = '#{location}', 
      price = #{price}
      WHERE id = #{space_id}
      RETURNING id, name,
      description, location,
      price, user_id;"
    ).first

    Space.new(
      space['id'],
      space['name'],
      space['description'],
      space['location'],
      space['price'],
      space['user_id']
    )
  end

  def self.delete(space_id:)
    DatabaseConnection.query(
      "DELETE FROM spaces WHERE id = '#{space_id}';"
    )
  end

  private

  def self.escape_apostrophes(string)
    string.gsub(/\'/, "''")
  end
end
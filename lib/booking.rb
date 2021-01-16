class Booking
  attr_reader :id, :space_id, :user_id, :check_in, :booked

  def initialize(check_in, booked = false, space_id, user_id, id)
    @check_in = check_in
    @booked = booked
    @space_id = space_id.to_s
    @user_id = user_id.to_s
    @id = id
  end

  def self.create(check_in:, booked:, space_id:, user_id:)
    result = DatabaseConnection.query("INSERT INTO bookings (check_in, booked, space_id, user_id)
                                  VALUES ('#{check_in}', '#{booked}', #{space_id}, '#{user_id}')
                                  RETURNING id, check_in, booked, space_id, user_id;")
    Booking.new(result[0]['check_in'],
                result[0]['booked'],
                result[0]['space_id'],
                result[0]['user_id'],
                result[0]['id'])
  end

  def self.retrieve_booking
    result = DatabaseConnection.query('SELECT * FROM bookings;')
    result.map do |booking|
      Booking.new(booking['check_in'], booking['booked'], booking['space_id'], booking['user_id'], booking['id'])
    end
  end

  def self.retrieve_requests_made(user_id:)
    DatabaseConnection.query(
      "SELECT s.name, s.description, 
       s.location, s.price, b.check_in, 
       u.name AS host_name
       FROM spaces AS s
       INNER JOIN bookings AS b
       ON b.space_id = s.id
       INNER JOIN users AS u
       ON s.user_id = u.id
       WHERE b.user_id = '#{user_id}'
       AND b.booked = FALSE"
    )
  end

  def self.retrieve_requests_received(user_id:)
    DatabaseConnection.query(
      "SELECT s.name, s.description, 
       s.location, s.price, b.check_in, 
       u.name AS guest_name, u.email
       FROM spaces AS s
       INNER JOIN bookings AS b
       ON b.space_id = s.id
       INNER JOIN users AS u
       ON b.user_id = u.id
       WHERE s.user_id = '#{user_id}'
       AND b.booked = FALSE;"
    )
  end

  def self.confirm(booking_id:)
    DatabaseConnection.query("UPDATE bookings SET booked = TRUE WHERE id = '#{booking_id}' RETURNING booked;")
  end

  def self.deny(booking_id:)
    DatabaseConnection.query("DELETE FROM bookings WHERE id='#{booking_id}';")
  end

  def self.retrieve_confirmed_bookings(host_or_guest:, user_id:)
    case host_or_guest
    when 'guest'
      result = DatabaseConnection.query("SELECT * FROM bookings JOIN spaces ON (space_id = spaces.id)
                                           WHERE bookings.user_id = '#{user_id}' AND booked=TRUE;")
    when 'host'
      result = DatabaseConnection.query("SELECT bookings.id, bookings.user_id, bookings.check_in, spaces.name, spaces.user_id
                                        FROM bookings JOIN spaces ON (space_id = spaces.id)
                                        WHERE space_id IN (SELECT id FROM spaces WHERE user_id='#{user_id}') AND booked=TRUE;")
    end
    result
  end
end

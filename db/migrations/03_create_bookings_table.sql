CREATE TABLE bookings (
  id SERIAL PRIMARY KEY, 
  space_id INTEGER REFERENCES spaces (id), 
  user_id INTEGER REFERENCES users (id), 
  check_in DATE, 
  check_out DATE, 
  booked BOOLEAN
);
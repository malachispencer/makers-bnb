CREATE TABLE bookings (
  id SERIAL PRIMARY KEY, 
  space_id INTEGER REFERENCES spaces (id) ON DELETE CASCADE, 
  user_id INTEGER REFERENCES users (id), 
  check_in DATE,
  booked BOOLEAN
);
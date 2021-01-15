CREATE TABLE spaces (
  id SERIAL PRIMARY KEY, 
  name VARCHAR(50), 
  description VARCHAR(500), 
  location VARCHAR(50), 
  price INTEGER, 
  user_id INTEGER REFERENCES users (id)
);
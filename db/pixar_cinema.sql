DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS movies;

CREATE TABLE customers(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  funds NUMERIC,
  annual_pass BOOLEAN NOT NULL
);

CREATE TABLE movies(
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  price NUMERIC NOT NULL CHECK (price > 0),
  show_time TIME NOT NULL,
  available_tickets INT4
);

CREATE TABLE tickets(
  id SERIAL4 PRIMARY KEY,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  movie_id INT4 REFERENCES movies(id) ON DELETE CASCADE
);
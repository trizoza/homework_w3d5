require_relative ('../db/sql_runner')

class Movie

  attr_reader :id
  attr_accessor :title, :price, :show_time, :capacity, :available_tickets

  def initialize(options)
    @id = options['id'].to_i unless options['id'].nil?
    @title = options['title']
    @price = options['price'].to_f #find out how to make it with 2 decimal values
    @capacity = options['capacity'].to_i
    @available_tickets = options['available_tickets'].to_i
  end

  def save()
    sql = "
      INSERT INTO movies (title, price, capacity, available_tickets)
      VALUES ('#{@title}', #{@price}, #{@capacity}, #{@capacity})
      RETURNING *;
    "
    @id = SqlRunner.run( sql )[0]['id'].to_i
    puts "Movie with title #{@title} has been created!"
  end

  def show()
    sql = "
      SELECT * FROM movies
      WHERE id = #{@id};
    "
    return SqlRunner.run( sql )[0]
  end

  def delete()
    sql = "
      DELETE FROM movies
      WHERE id = #{@id};
    "
    puts "Movie with title #{@title} has been deleted from movies table!"
    SqlRunner.run( sql )
  end

  def update()
    sql = "
      UPDATE movies
      SET (title, price) = ('#{@title}', #{price})
      WHERE id = #{@id};
    "
    SqlRunner.run( sql )
  end

  def self.all()
    sql = "
      SELECT * FROM movies;
    "
    return Movie.get_many( sql )
  end

  def self.delete_all()
    sql = "
      DELETE FROM movies;
    "
    SqlRunner.run( sql )
    puts "Movie table was deleted, entirely!"
  end

  def customers()
    sql = "
      SELECT customers.* FROM customers
      INNER JOIN tickets ON tickets.customer_id = customers.id
      WHERE #{@id} = movie_id;
    "
    return Customer.get_many( sql )
  end

  def tickets_sold()
    sql = "
      SELECT customers.name FROM customers
      INNER JOIN tickets ON tickets.customer_id = customers.id
      WHERE #{@id} = movie_id;
    "
    number_of_tickets = Customer.get_many( sql )
    return number_of_tickets.count()
  end

  def popular_time()
    ##### CRETING PG OBJECT WITH ALL SHOWTIMES OF MOVIE ##########################
    sql = "
      SELECT show_time FROM tickets
      WHERE movie_id = #{@id};
    "
    array_of_showtimes = SqlRunner.run( sql ).map { |ticket| Ticket.new(ticket).show_time }
    ##### TURNING PG OBJECT INTO HASH WHERE KEY AND VALUES REPRESENT ONE TIME ####
    times_grouped_to_hash = {}
    times_grouped_to_hash = array_of_showtimes.group_by { |i| i }
    ##### TURNING HASH INTO ARRAY OF ARRAYS WITH VALUES ONLY #####################
    times_hash_values = []
    times_hash_values = times_grouped_to_hash.values
    ##### KEEPING ONLY THE ARRAY WITH MOST VALUES ################################
    array_of_most_common_times_only = []
    array_of_most_common_times_only = times_hash_values.max_by { |x| x.count() }
    ##### RETURNING MOST POPULAR TIME ############################################
    most_common_time = array_of_most_common_times_only.first()
    ##### RETURNING HOW MANY TICKETS WERE SOLD FOR THE MOST POPULAR TIME #########
    number_of_sold_tickets = array_of_most_common_times_only.count()
    puts "Most popular time for #{@title} movie is at #{most_common_time} with #{number_of_sold_tickets} sold tickets."
  end

  def self.find_movie_details( movie_id )
    sql = "
      SELECT * FROM movies
      WHERE id = #{ movie_id };
    "
    return SqlRunner.run( sql )[0]
  end

  def self.get_many( sql )
    return SqlRunner.run( sql ).map { |movie| Movie.new(movie) }
  end

end
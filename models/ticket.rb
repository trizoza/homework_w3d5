require_relative ('../db/sql_runner')

class Ticket

  attr_reader :customer_id, :movie_id

  def initialize( options )
    @id = options['id'].to_i unless options['id'].nil?
    @customer_id = options['customer_id'].to_i
    @movie_id = options['movie_id'].to_i
  end

  def buy()
    ########## Customer & Movie Search ############################
    sql_to_find_customer = "
      SELECT * FROM customers
      WHERE id = #{@customer_id};
    "
    customer = SqlRunner.run( sql_to_find_customer )[0]
    sql_to_find_movie = "
      SELECT * FROM movies
      WHERE id = #{@movie_id};
    "
    movie = SqlRunner.run( sql_to_find_movie )[0]
    available_tickets = movie['available_tickets'].to_i
    customer_funds = customer['funds'].to_f
    movie_price = movie['price'].to_f
    annual_pass = customer['annual_pass']
    ########## Availability check ################################
    if available_tickets > 0
      ########## Annual pass check ###############################
      if annual_pass == "t"     
        ########## Create ticket #################################
        sql = "
          INSERT INTO tickets (customer_id, movie_id)
          VALUES (#{@customer_id}, #{@movie_id})
          RETURNING *;
        "
        @id = SqlRunner.run( sql )[0]['id'].to_i
        ########## Update movie ##################################
        available_tickets -= 1
        sql_movie_update ="
          UPDATE movies
          SET (available_tickets) = (#{available_tickets})
          WHERE id = #{@movie_id};
        "
        SqlRunner.run( sql_movie_update )
      ########## Customer funds check ############################
      elsif customer_funds >= movie_price
        ########## Create ticket #################################
        sql = "
          INSERT INTO tickets (customer_id, movie_id)
          VALUES (#{@customer_id}, #{@movie_id})
          RETURNING *;
        "
        @id = SqlRunner.run( sql )[0]['id'].to_i
        ########## Update movie ##################################
        available_tickets -= 1
        sql_movie_update ="
          UPDATE movies
          SET (available_tickets) = (#{available_tickets})
          WHERE id = #{@movie_id};
        "
        SqlRunner.run( sql_movie_update )
        ########## Update customer ###############################
        customer_funds -= movie_price
        sql_customer_update ="
          UPDATE customers
          SET (funds) = (#{customer_funds})
          WHERE id = #{@customer_id};
        "
        SqlRunner.run( sql_customer_update )
      else
        puts "Ticket could not be created, because customer has insufficient funds."
      end
    else
      puts "Movie is sold out, cannot create new ticket."
    end
  end

  def cancel()
    ############## FIND CUSTOMER #################################
    sql_to_find_customer = "
      SELECT * FROM customers
      WHERE id = #{@customer_id};
    "
    customer = SqlRunner.run( sql_to_find_customer )[0]
    ############## FIND MOVIE ####################################
    sql_to_find_movie = "
      SELECT * FROM movies
      WHERE id = #{@movie_id};
    "
    movie = SqlRunner.run( sql_to_find_movie )[0]
    ######REFUND CUSTOMER UNLESS ANNUAL PASS HOLDER ##############
    if customer['annual_pass'] == "f"
      movie_price = movie['price'].to_f
      customer_funds = customer['funds'].to_f
      customer_funds += movie_price
      refund_sql = "
        UPDATE customers
        SET funds = #{customer_funds}
        WHERE id = #{@customer_id};
      "
      SqlRunner.run( refund_sql )
      puts "Customer #{customer['name']} was refunded #{movie['price']}$ after ticket cancellation."
    end
    ##### INCREASE AVAILABLE TICKETS FOR MOVIE ###################
    movie_available_tickets = movie['available_tickets'].to_i
    movie_available_tickets += 1
    capacity_increase_sql = "
      UPDATE movies
      SET available_tickets = #{movie_available_tickets}
      WHERE id = #{@movie_id};
    "
    SqlRunner.run( capacity_increase_sql )
    puts "Movie #{movie['title']} screened at #{movie['show_time']} has #{movie_available_tickets} available tickets after the cancellation."
    ############### DELETE TICKET ################################
    sql = "
      DELETE FROM tickets
      WHERE id = #{@id};
    "
    SqlRunner.run( sql )
  end

  def self.all()
    sql = "
      SELECT * FROM tickets;
    "
    return SqlRunner.run( sql ).map { |ticket| Ticket.new(ticket) }
  end

end
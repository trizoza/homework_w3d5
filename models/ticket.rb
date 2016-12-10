require_relative ('../db/sql_runner')

class Ticket

  attr_reader :customer_id, :movie_id

  def initialize( options )
    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @movie_id = options['movie_id'].to_i
  end

  def buy()
    sql = "
      SELECT * FROM customers
      WHERE id = #{@customer_id};
    "
    ################
    if customer.funds > movie.price
      if movie.available_tickets > 0
        sql = "
          INSERT INTO tickets (customer_id, movie_id)
          VALUES (#{@customer_id}, #{@movie_id})
          RETURNING *;
        "
        @id = SqlRunner.run( sql )[0]['id'].to_i
      else
        puts "Movie is sold out, cannot create new ticket."
      end
    else
      puts "Ticket cannot be created, because customer has insufficient funds."
    end
  end

end
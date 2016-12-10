require_relative ('../db/sql_runner')

class Movie

  attr_reader :id
  attr_accessor :title, :price, :show_time, :available_tickets

  def initialize(options)
    @id = options['id'].to_i unless options['id'].nil?
    @title = options['title']
    @price = options['price'].to_f #find out how to make it with 2 decimal values
    @show_time = options['show_time']
    @available_tickets = options['available_tickets'].to_i
  end

  def save()
    sql = "
      INSERT INTO movies (title, price, show_time, available_tickets)
      VALUES ('#{@title}', #{@price}, '#{@show_time}', #{@available_tickets})
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
      SET (title, price, show_time) = ('#{@title}', #{price}, '#{@show_time}')
      WHERE id = #{@id};
    "
    SqlRunner.run( sql )
  end

  def self.all()
    sql = "
      SELECT * FROM movies;
    "
    return SqlRunner.run( sql ).map { |movie| Movie.new(movie) }
  end

  def self.delete_all()
    sql = "
      DELETE FROM movies;
    "
    SqlRunner.run( sql )
    puts "Movie table was deleted, entirely!"
  end

end
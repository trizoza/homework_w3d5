require_relative ('../db/sql_runner')

class Customer

  attr_reader :id
  attr_accessor :name, :funds, :annual_pass

  def initialize( options )
    @id = options['id'].to_i unless options['id'].nil?
    @name = options['name']
    @funds = options['funds'].to_i
    @annual_pass = false
  end

  def save()
    sql = "
      INSERT INTO customers (name, funds, annual_pass)
      VALUES ('#{@name}', #{@funds}, #{@annual_pass})
      RETURNING *;
    "
    @id = SqlRunner.run( sql )[0]['id'].to_i
    puts "Customer named #{@name} has been created!"
  end

  def show()
    sql = "
      SELECT * FROM customers
      WHERE id = #{@id};
    "
    return SqlRunner.run( sql )[0]
  end

  def delete() #ADD HERE DELETION FROM TICKETS TABLE TOO
    sql = "
      DELETE FROM customers
      WHERE id = #{@id};
    "
    puts "Customer named #{@name} has been deleted from customers table!"
    SqlRunner.run( sql )
  end

  def update()
    sql = "
      UPDATE customers
      SET (name) = ('#{@name}')
      WHERE id = #{@id};
    "
    SqlRunner.run( sql )
  end

  def self.all()
    sql = "
      SELECT * FROM customers;
    "
    return SqlRunner.run( sql ).map { |customer| Customer.new(customer) }
  end

  def self.delete_all()
    sql = "
      DELETE FROM customers;
    "
    SqlRunner.run( sql )
    puts "Customer table was deleted, entirely!"
  end

end
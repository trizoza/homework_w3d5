require_relative ('../db/sql_runner')

class Customer

  attr_reader :id
  attr_accessor :name, :funds, :annual_pass

  def initialize( options )
    @id = options['id'].to_i unless options['id'].nil?
    @name = options['name']
    @funds = options['funds'].to_f
    @annual_pass = options['annual_pass']
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

  def delete()
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
      SET (funds) = (#{@funds})
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

  def buy_annual_pass()
    ########### Customer declaration #########################
    sql_to_find_customer = "
      SELECT * FROM customers
      WHERE id = #{@id};
    "
    customer = SqlRunner.run( sql_to_find_customer )[0]
    customer_funds = customer['funds'].to_f
    customer_annual_pass = customer['annual_pass']
    ########## Funds check ###################################
    if customer_funds >= 100
      ### Funds update & Annual pass update to TRUE ##########
      customer_funds -= 100
      customer_annual_pass = true
      sql_customer_update ="
        UPDATE customers
        SET (funds, annual_pass) = (#{customer_funds}, #{customer_annual_pass})
        WHERE id = #{@id};
      "
      SqlRunner.run( sql_customer_update )
    else
      puts "Customer cannot buy the annual pass, because his funds are lower than 100$."
    end
  end

end
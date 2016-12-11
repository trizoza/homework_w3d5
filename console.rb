require ('pry')
require_relative ('models/customer')
require_relative ('models/movie')
require_relative ('models/ticket')

Customer.delete_all()
Movie.delete_all()

customer1 = Customer.new({ "name" => "Matthew", "funds" => 350, "annual_pass" => false })
customer1.save()
customer2 = Customer.new({ "name" => "Beth", "funds" => 500, "annual_pass" => false })
customer2.save()
customer3 = Customer.new({ "name" => "Craig", "funds" => 300, "annual_pass" => false  })
customer3.save()
customer4 = Customer.new({ "name" => "Rick", "funds" => 250, "annual_pass" => false  })
customer4.save()
customer5 = Customer.new({ "name" => "Simon", "funds" => 400, "annual_pass" => false  })
customer5.save()

movie1 = Movie.new({ "title" => "Monsters", "price" => 9.99, "capacity" => 5 })
movie1.save()
movie2 = Movie.new({ "title" => "Up!", "price" => 9.99, "capacity" => 5 })
movie2.save()
movie3 = Movie.new({ "title" => "Cars 2", "price" => 8.99, "capacity" => 5 })
movie3.save()
movie4 = Movie.new({ "title" => "Toy Story", "price" => 5.99, "capacity" => 5 })
movie4.save()
movie5 = Movie.new({ "title" => "Wall.e", "price" => 7.99, "capacity" => 5 })
movie5.save()
movie6 = Movie.new({ "title" => "Pixar Short Films", "price" => 7.99, "capacity" => 5 })
movie6.save()
movie7 = Movie.new({ "title" => "Ratatouille", "price" => 7.99, "capacity" => 5 })
movie7.save()
movie8 = Movie.new({ "title" => "Brave", "price" => 7.99, "capacity" => 5 })
movie8.save()
movie9 = Movie.new({ "title" => "Inside Out", "price" => 8.99, "capacity" => 5 })
movie9.save()
movie10 = Movie.new({ "title" => "Bugs Life", "price" => 3.99, "capacity" => 5 })
movie10.save()

ticket1 = Ticket.new({ "customer_id" => customer1.id, "movie_id" => movie1.id, "show_time" => "20:00" })
ticket1.buy()
ticket2 = Ticket.new({ "customer_id" => customer2.id, "movie_id" => movie2.id, "show_time" => "20:00" })
ticket2.buy()
ticket3 = Ticket.new({ "customer_id" => customer3.id, "movie_id" => movie3.id, "show_time" => "20:00"  })
ticket3.buy()

customer4.buy_annual_pass()

ticket4 = Ticket.new({ "customer_id" => customer4.id, "movie_id" => movie4.id, "show_time" => "20:00" })
ticket4.buy()
ticket5 = Ticket.new({ "customer_id" => customer4.id, "movie_id" => movie5.id, "show_time" => "20:00" })
ticket5.buy()
ticket6 = Ticket.new({ "customer_id" => customer3.id, "movie_id" => movie2.id, "show_time" => "22:00" })
ticket6.buy()
ticket7 = Ticket.new({ "customer_id" => customer4.id, "movie_id" => movie2.id, "show_time" => "22:00" })
ticket7.buy()
ticket8 = Ticket.new({ "customer_id" => customer5.id, "movie_id" => movie2.id, "show_time" => "22:00" })
ticket8.buy()

binding.pry
nil
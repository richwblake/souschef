class Souschef::CLI
  def call
    puts "Welcome to Souschef, let's get cookin'!"
    find_dish_by_name
  end

  def get_input_from_user
    input = gets.chomp
  end

  def find_dish_by_name
    puts "Please enter the name of the dish:"
    dish = Souschef::Dish.new(Souschef::ApiHandler.fetch_dish_by_name(get_input_from_user))
    print_dish(dish)
  end

  def print_dish(dish)
    puts "----------Dish Details----------"
    puts "Dish Name: " + dish.name
    puts "Type of Dish: " + dish.category
    puts "Regional detail: " + dish.region
    puts ""
    puts "Ingredients: \n"
    dish.ingredients.each_with_index { |ingredient, index|
      puts "  #{index + 1}. #{dish.measurements[index]} #{ingredient}"
    }
    puts ""
    puts "Instructions: \n#{dish.instructions.gsub(/\./, ".\n")}\n"
  end
end

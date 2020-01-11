class Souschef::CLI
  def call
    puts "Welcome to Souschef 0.1.0, let's get cookin'!"
    menu
    # find_dish_by_name
    # list_dishes_by_first_letter
    # find_random_dish
    # list_dish_categories
    # search_by_category
  end

  def menu
    puts "------------------"
    puts "       Menu       "
    puts "------------------"
    puts "Welcome to the menu. You can choose a search method by simply\ntyping in the name of one of the methods below."
    puts ""
    puts " - Search by name"
    puts " - Search by first letter"
    puts " - Search by category"
    puts " - Get random dish"
    print "\n:"
    input = get_input_from_user

  end

  def get_input_from_user
    gets.chomp
  end

  def find_dish_by_name
    puts "Please enter the name of the dish:"
    dish = Souschef::Dish.new(Souschef::ApiHandler.fetch_dish_by_name(get_input_from_user))
    print_dish(dish)
  end

  def list_dishes_by_first_letter
    puts "Search dishes by which letter?:"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_first_letter(input)
    dishes["meals"].each { |dish| puts dish["strMeal"] }
    find_dish_by_name
  end

  def list_dish_categories
    puts "----------Categories----------"
    categories = Souschef::ApiHandler.fetch_dish_categories
    categories["categories"].each { |category| puts category["strCategory"]}
  end

  def search_by_category
    puts "Please enter the category by which you'd like to search:"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_category(input)
    dishes["meals"].each{ |dish| puts dish["strMeal"] }
    # binding.pry
  end

  def find_random_dish
    puts "Fetching you a random meal... How adventurous!"
    dish = Souschef::Dish.new(Souschef::ApiHandler.fetch_random_dish)
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

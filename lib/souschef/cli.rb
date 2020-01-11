class Souschef::CLI
  def call
    puts "Welcome to Souschef 0.1.0, let's get cookin'!"
    menu
  end

  # Prints menu format and options
  def menu
    puts "------------------"
    puts "       Menu       "
    puts "------------------"
    puts "Welcome to the menu. You can choose a search method by simply\ntyping in the name of one of the methods below. You can also exit\nby typing exit."
    puts ""
    puts " - Search by name"
    puts " - Search by first letter"
    puts " - Search by category"
    puts " - Get random dish"
    puts " - Exit"
    puts ""

    # Handles input and control flow for 1st level
    # handle_menu_input returns the input as a String
    menu_input = handle_menu_input

    # Allows user to return to menu or exit program after a dish has been displayed
    if menu_input != "exit"
      puts "Press enter to return to the menu, or type anything to exit the application."
      input = get_input_from_user
      input == "" ? menu : exit
    else
      exit
    end
  end

  def handle_menu_input
    input = get_input_from_user

    case input
    when "search by name"
      find_dish_by_name
    when "search by first letter"
      list_dishes_by_first_letter
    when "search by category"
      list_dish_categories
    when "get random dish"
      find_random_dish
    when "exit"
      exit
    else
      print "Please try again\n"
      handle_menu_input
    end
    input
  end

  def get_input_from_user
    print ":"
    gets.chomp.strip.downcase
  end

  def find_dish_by_name
    puts "Please enter the name of the dish:"
    dish = Souschef::Dish.new(Souschef::ApiHandler.fetch_dish_by_name(get_input_from_user))
    print_dish(dish)
  end

  def list_dishes_by_first_letter
    puts "Search dishes by which letter?"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_first_letter(input)
    dishes["meals"].each { |dish| puts dish["strMeal"] }
    find_dish_by_name
  end

  def list_dish_categories
    puts "----------Categories----------"
    categories = Souschef::ApiHandler.fetch_dish_categories
    categories["categories"].each { |category| puts category["strCategory"]}
    search_by_category
  end

  def search_by_category
    puts "Please enter the category by which you'd like to search:"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_category(input)
    dishes["meals"].each{ |dish| puts dish["strMeal"] }
    find_dish_by_name
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
    puts "Instructions: \n#{dish.instructions.gsub(/\./, ".\n")}"
    puts "----------------------------------------------------------------------"
  end

  def exit
    puts "See you in the kitchen soon!"
  end
end

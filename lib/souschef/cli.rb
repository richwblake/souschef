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
    puts " - Search by region"
    puts " - Search by ingredient"
    puts " - Get random dish"
    puts " - Search History"
    puts " - Exit"
    puts ""

    # menu_input == nil unless user input was exit
    # if user input was exit, menu_input == "exit"
    menu_input = handle_menu_input

    # Allows user to return to menu or exit program after a dish has been displayed
    # if #handle_menu_input returns "exit", the else statement runs and #exit is called.
    # Recursive calls are made to #menu if and only if the return key is pressed
    # If input any value besides the empty string, #exit is called
    if menu_input != "exit"
      puts "Press enter to return to the menu, or type anything to exit the application."
      input = get_input_from_user
      input == "" ? menu : exit
    else
      exit
    end
  end

  # First gets input from user, and then selects path to take from input
  # Recursive calls are made if input != one of the chosen search methods
  # returns the value of input if input == exit
  def handle_menu_input
    input = get_input_from_user

    case input
    when "search by name"
      find_dish_by_name
    when "search by first letter"
      search_by_first_letter
    when "search by category"
      list_dish_categories
    when "search by region"
      list_dishes_by_region
    when "search by ingredient"
      search_by_ingredient
    when "get random dish"
      find_random_dish
    when "search history"
      print_search_history
    when "exit"
      input
    else
      print "Please try again\n"
      handle_menu_input
    end
  end

  # Adds a ":" character without a newline, which allows for console-like formatting
  # Strips input of leading and trailing whitespace and changes entire string
  # to lowercase values, then returns the formatted value
  def get_input_from_user
    print ":"
    gets.chomp.strip.downcase
  end

  # #find_dish_by_name is the terminal method call in any given search tree in the application
  # Creates a Dish object, which is then saved in the @@all Dish class variable
  # It returns nil upon every call
  def find_dish_by_name
    puts "Please enter the name of the dish:"
    dish = Souschef::Dish.new(Souschef::ApiHandler.fetch_dish_by_name(get_input_from_user))
    print_dish(dish)
  end

  #
  def search_by_first_letter
    puts "Search dishes by which letter?"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_first_letter(input)
    dishes["meals"].each { |dish| puts dish["strMeal"] }
    find_dish_by_name
  end

  # Lists categories of all dishes and calls sibling method #search_by_category to prompt user
  def list_dish_categories
    puts "---------- Categories ----------"
    categories = Souschef::ApiHandler.fetch_dish_categories
    categories["categories"].each { |category| puts category["strCategory"]}
    puts "--------------------------------"
    search_by_category
  end

  # Prompts user to search by specific category and then calls #find_dish_by_name to search for a dish
  def search_by_category
    puts "Please enter the category by which you'd like to search:"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_category(input)
    dishes["meals"].each{ |dish| puts dish["strMeal"] }
    find_dish_by_name
  end

  # Lists regions of all dishes and calls sibling method #search_by_region to prompt user
  def list_dishes_by_region
    puts "------------ Dishes by Region ------------"
    regions = Souschef::ApiHandler.fetch_dish_regions
    regions["meals"].each { |dish| puts dish["strArea"] }
    puts "------------------------------------------"
    search_by_region
  end

  # Prompts user to search by specific region and then calls #find_dish_by_name to search for a dish
  def search_by_region
    puts "Please enter the region by which you'd like to search:"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_region(input)
    dishes["meals"].each { |dish| puts dish["strMeal"] }
    find_dish_by_name
  end

  # Prompts user to search by specific ingredient and then calls #find_dish_by_name to search for a dish
  def search_by_ingredient
    puts "Please enter the region by which you'd like to search:"
    input = get_input_from_user
    dishes = Souschef::ApiHandler.fetch_dishes_by_ingredient(input)
    dishes["meals"].each { |dish| puts dish["strMeal"] }
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

  def print_search_history
    if Souschef::Dish.all.empty?
      puts "Cannot find any recent searches."
    else
      Souschef::Dish.all.each_with_index { |dish, number| puts "#{number + 1}. #{dish.name}"}
    end
  end

  def exit
    puts "See you in the kitchen soon!"
  end
end

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
    input = Souschef::ApiHandler.fetch_dish_by_name(get_input_from_user)
    if input != nil
      dish = Souschef::Dish.new(input)
      print_dish(dish)
    else
      cannot_find_dish
      find_dish_by_name
    end
  end

  # Searches and displays all dishes that begin with the user's letter
  # If input is not a single letter, recursive calls are made to #search_by_first_letter
  # upon successful entry, displays all dishes requested and call #find_dish_by_name
  def search_by_first_letter
    puts "Search dishes by which letter?"
    input = get_input_from_user

    if input.length == 1 && input =~ /[a-z]/
      dishes = Souschef::ApiHandler.fetch_dishes_by_first_letter(input)
      dishes["meals"].each { |dish| puts dish["strMeal"] }
      find_dish_by_name
    else
      puts "The input #{input} is not one letter. Please try again"
      search_by_first_letter
    end
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
  # if the API class returns nill (because the request was invalid due to a bad input), #search_by_category makes recursive
  # calls until the API class returns a valid hash
  def search_by_category
    puts "Please enter the category by which you'd like to search:"
    input = get_input_from_user
    request_from_input = Souschef::ApiHandler.fetch_dishes_by_category(input)
    if request_from_input != nil
      dishes = request_from_input
      puts "---------- #{input.capitalize} Dishes ----------"
      dishes["meals"].each{ |dish| puts dish["strMeal"] }
      puts "---------------------------------------------"
      find_dish_by_name
    else
      puts "#{input} not found as a category. Please try again"
      search_by_category
    end
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
  # If the request is invalid due to a region not existing, input == nil
  # If input is nil, recursive calls are made to #search_by_region until succesful region is inputted
  def search_by_region
    puts "Please enter the region by which you'd like to search:"
    input = get_input_from_user
    request_from_input = Souschef::ApiHandler.fetch_dishes_by_region(input)
    if request_from_input != nil
      dishes = request_from_input
      puts "---------- #{input.capitalize} Dishes ----------"
      dishes["meals"].each { |dish| puts dish["strMeal"] }
      puts "-----------------------------------------------"
      find_dish_by_name
    else
      puts "#{input} not found as a region, please try again"
      search_by_region
    end
  end

  # Prompts user to search by specific ingredient and then calls #find_dish_by_name to search for a dish
  def search_by_ingredient
    puts "Please enter the region by which you'd like to search:"
    input = get_input_from_user
    request_from_input = Souschef::ApiHandler.fetch_dishes_by_ingredient(input)
    if request_from_input != nil
      dishes = request_from_input
      puts "---------- Dishes That Include #{input.capitalize} ----------"
      dishes["meals"].each { |dish| puts dish["strMeal"] }
      puts "-----------------------------------------------------------"
      find_dish_by_name
    else
      puts "Cannot find #{input} as an ingredient, please try again"
      search_by_ingredient
    end
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
      puts "---------- Search History ----------"
      Souschef::Dish.all.each_with_index { |dish, number| puts "#{number + 1}. #{dish.name}"}
      puts "------------------------------------"
    end
  end

  def cannot_find_dish
    puts "Cannot find the dish you are looking for... Please try again"
  end

  def exit
    puts "See you in the kitchen soon!"
  end
end

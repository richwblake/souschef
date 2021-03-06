class Souschef::ApiHandler
  @@BASE_URL = "https://www.themealdb.com/api/json/v1/1/"

  def self.fetch_dish_by_name(name)
    response = self.generate_JSON_from_pathname("search.php?s=", name)
    response != nil ? self.json_to_dish_args(response) : nil
  end

  def self.fetch_dishes_by_first_letter(letter)
    self.generate_JSON_from_pathname("search.php?f=", letter)
  end

  def self.fetch_random_dish
    self.json_to_dish_args(self.generate_JSON_from_pathname("random.php"))
  end

  def self.fetch_dish_categories
    self.generate_JSON_from_pathname("categories.php")
  end

  def self.fetch_dishes_by_category(category)
    self.generate_JSON_from_pathname("filter.php?c=", category)
  end

  def self.fetch_dish_regions
    self.generate_JSON_from_pathname("list.php?a=list")
  end

  def self.fetch_dishes_by_region(region)
    self.generate_JSON_from_pathname("filter.php?a=", region)
  end

  def self.fetch_dishes_by_ingredient(ingredient)
    self.generate_JSON_from_pathname("filter.php?i=", ingredient)
  end

  # Takes a path extension and an optional value as parameters
  # Creates a full path and requests api information from that path
  # response will always be a hash
  # if the request is invalid, response == a hash with one key, whose value is nil
  # valid_response is either true or false, depending on if the request is invalid
  # If request is invalid, returns nil. If valid, returns the response from the API
  def self.generate_JSON_from_pathname(extension, value = "")
    path = @@BASE_URL + extension + value
    uri = URI(path)
    response = JSON.parse(Net::HTTP.get(uri))

    valid_response = self.check_for_valid_response(response)
    valid_response == true ? response : nil
    # binding.pry
  end

  # Checks to see if response has the invalid hash structure mentioned above
  # If it is an invalid request, return false
  # If the request is valid, return true
  def self.check_for_valid_response(response)
    response_array = response.to_a
    response_array[0][1] != nil ? true : false
    # binding.pry
  end

  def self.json_to_dish_args(json)
    data_hash = {}

    # cleans hash to include only key/value pairs where value is not nil or the empty string
    json["meals"][0].each { |key, attribute|
       data_hash[key] = attribute unless attribute == nil || attribute.strip == ""
    }

    # creates array of ingredients of type String
    ingredients_array = []
    data_hash.each { |key, attribute|
      ingredients_array << attribute if key.include?("strIngredient")
    }

    # creates array of measurements for ingredients of type String
    measurements_array = []
    data_hash.each { |key, attribute|
      measurements_array << attribute if key.include?("strMeasure")
    }

    # creates a new hash to pass as an argument to Dish.new
    dish_args = {
      "name" => data_hash["strMeal"],
      "category" => data_hash["strCategory"],
      "region" => data_hash["strArea"],
      "ingredients" => ingredients_array,
      "measurements" => measurements_array,
      "instructions" => data_hash["strInstructions"]
    }
  end
end

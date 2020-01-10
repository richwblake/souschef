class Souschef::ApiHandler
  @@BASE_URL = "https://www.themealdb.com/api/json/v1/1/search.php"

  def self.json_to_dish_args(json)
    data_hash = {}
    json["meals"][0].each { |key, attribute|
       puts data_hash[key] = attribute unless attribute == nil || attribute.strip == ""
    }

    # binding.pry

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


    student_args = {
      "name" => data_hash["strMeal"],
      "category" => data_hash["strCategory"],
      "region" => data_hash["strArea"],
      "ingredients" => ingredients_array,
      "measurements" => measurements_array,
      "instructions" => data_hash["strInstructions"]
    }
  end

  def self.fetch_dish_by_name(name)
    path = dish = @@BASE_URL + "?s=" + name
    uri = URI(path)

    response = Net::HTTP.get(uri)
    self.json_to_dish_args(JSON.parse(response))
  end
end

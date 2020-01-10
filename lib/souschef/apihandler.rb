class Souschef::ApiHandler
  @@BASE_URL = "https://www.themealdb.com/api/json/v1/1/search.php"

  def self.json_to_dish_args(json)
    data_hash = {}
    json["meals"][0].each { |key, attribute|
       data_hash[key] = attribute unless attribute == nil || attribute == ""
    }

    student_args = {
      "name" => data_hash["strMeal"],
      "category" => data_hash["strCategory"],
      "region" => data_hash["strArea"]
    }
  end

  def self.fetch_dish_by_name(name)
    path = dish = @@BASE_URL + "?s=" + name
    uri = URI(path)

    response = Net::HTTP.get(uri)
    self.json_to_dish_args(JSON.parse(response))
  end
end

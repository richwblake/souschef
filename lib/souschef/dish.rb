class Souschef::Dish
  attr_accessor :name, :category, :region, :ingredients, :measurements, :instructions

  def initialize(args)
    args.each { |key, attribute|
      self.send("#{key}=", attribute)
    }
  end
end

class Souschef::Dish
  attr_accessor :name, :category, :region, :ingredients, :measurements, :instructions

  @@all = []

  def initialize(args)
    args.each { |key, attribute|
      self.send("#{key}=", attribute)
    }
    @@all << self
  end

  def self.all
    @@all
  end
end

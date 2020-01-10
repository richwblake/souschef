class Souschef::Dish
  attr_accessor :name, :category, :region

  def initialize(args)
    args.each { |key, attribute|
      self.send("#{key}=", attribute)
    }
  end
end

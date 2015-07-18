class User
  attr_accessor :name, :image
  STORE = [ 'Tony Stark', 'Hulk', 'Thor', 'Spider-Man',
             'Black Widow', 'Groot', 'Rocket Raccoon',
             'Star-Lord', 'Daredevil', 'Ultron', 'Red Skull',
             'Pip', 'Adam Warlock' ]


  def initialize(name)
    @name = name
    @image = name.downcase.split(' ').join('_') + '.jpg'
  end

  def self.find(name)
    all.select { |u| u.name.downcase == name.downcase }.first
  end

  def self.create(name)
    STORE.push(name)
  end

  def self.delete(name)
    STORE.delete(name)
  end

  class << self
    def all
      STORE.map { |name| User.new(name) }
    end
  end
end

class DataStructures
  attr_reader :provider

  def initialize
    @provider = Redis.new
  end

  def self.get
    new.provider
  end
end

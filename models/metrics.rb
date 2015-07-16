class Metrics
  attr_reader :weapon

  def initialize
    @weapon = DataStructures.get
  end

  def login_count_for(name)
    weapon.zincrby('users_logins', 1, name)
  end

  def count_login(name)
    weapon.zscore('users_logins', name)
  end

  def top_five_login
    weapon.zrevrange('users_logins', 0, 4)
  end

  def track_online(name)
    key  = Time.now.to_i
    weapon.sadd(key, name).tap do
      weapon.expire(key, 60 * 5)
    end
  end

  def users_online
    time_range = (Time.now.to_i - 60..Time.now.to_i).to_a
    weapon.sunion(time_range)
  end
end


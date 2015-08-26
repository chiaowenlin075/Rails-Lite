class Cat
  attr_accessor :flash

  def initialize
  @flash = {}
  @flash_now = {}
  end

  def []=(key, val)
    flash[key.to_s] = val
  end

  def now[]=(key, val)
    @flash_now[key] = val
  end

end

# class Cat
#   attr_accessor :flash
#
#   def initialize
#   @flash = {}
#   @flash_now = {}
#   end
#
#   def []=(key, val)
#     flash[key.to_s] = val
#   end
#
#   def now[]=(key, val)
#     @flash_now[key] = val
#   end
#
# end

require 'erb'

def cat_test
  "Hey! Regular function can also be used in views template!"
end

def index
  @cats = ["Gizmo"]
end

def render(opts = {})
  # opts.each do |k, v|
  #   define_method(k.to_s) do
  #     return v
  #   end
  # end
  b = binding
  opts.each do |k,v|
    b.local_variable_set(k.to_s, v) # set existing local variable `a'
  end

  result = ERB.new(File.read("test.html.erb")).result(b)
end

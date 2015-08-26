require_relative '../phase6/controller_base'
require_relative './flash'

module Phase8
  class ControllerBase < Phase6::ControllerBase
    # method exposing a `Flash` object
    def flash
      @flash ||= Flash.new(req)
    end
  end
end

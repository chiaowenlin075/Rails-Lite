require_relative '../phase9/controller_base'
require_relative './url_helpers'

module Phase10
  class ControllerBase < Phase9::ControllerBase
    extend UrlHelpers

    def initialize(req, res, route_params = {})
      super
      self.class.define_url_helpers
    end

    def link_to(show_text, url, opts = {})
      "<a href=\"#{url}\">#{show_text}</a>"
    end
  end
end

require 'json'
require 'webrick'

module Phase4
  class Session

    def initialize(req)
      cookie_data = req.cookies.find{ |cookie| cookie.name == '_rails_lite_app' }
      @session = cookie_data ? JSON.parse(cookie_data.value) : {}
    end

    def [](key)
      @session[key.to_s]
    end

    def []=(key, val)
      @session[key.to_s] = val
    end

    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
    end
  end
end

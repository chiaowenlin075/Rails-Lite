require 'json'
require 'webrick'

module Phase8
  class Flash
    def initialize(req)
      cookie_data = req.cookies.find{ |cookie| cookie.name == '_rails_lite_app_flash' }
      @old_flash = cookie_data ? JSON.parse(cookie_data.value) : {}
      @new_flash = {}
    end

    def [](key)
      if @flash_now[key.to_s]
        return @flash_now.delete(key.to_s)
      elsif @flash_now[key]
        return @flash_now.delete(key)
      elsif @flash_now[key.to_sym]
        return @flash_now.delete(key.to_sym)
      end
      @old_flash[key.to_s]
    end

    def []=(key, val)
      @new_flash[key.to_s] = val
    end

    def now
      @flash_now ||= {}
    end

    def store_flash(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash', @new_flash.to_json)
    end
  end
end

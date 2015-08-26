require 'json'
require 'webrick'

module Phase8
  class Flash
    def initialize(req)
      cookie_data = req.cookies.find{ |cookie| cookie.name == '_rails_lite_app_flash' }

      # old_flash store the flash we get from req, available for current action
      @old_flash = cookie_data ? JSON.parse(cookie_data.value) : {}
      # new_flash store the new flash that supposed to be used in the next action --> store_flash
      @new_flash = {}
    end

    def [](key)
      if @flash_now[key.to_s]  # if input key is symbol, but the key of hash is str
        return @flash_now.delete(key.to_s)
      elsif @flash_now[key] # both of them in same type
        return @flash_now.delete(key)
      elsif @flash_now[key.to_sym]  # if input key is string, but the key of hash is sym
        return @flash_now.delete(key.to_sym)
      end
      @old_flash[key.to_s]
    end

    def []=(key, val)  #force to store as string
      @new_flash[key.to_s] = val
    end

    def now
      @flash_now ||= {}
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flash(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash', @new_flash.to_json)
    end
  end
end

require 'json'
require 'webrick'

module Phase8
  class Flash
    # find the cookie for this app
    # deserialize the cookie into a hash
    attr_reader :new_flash
    def initialize(req)
      @req = req # need this for building a new empty flash instance for #now
      cookie_data = req.cookies.find{ |cookie| cookie.name == '_rails_lite_app_flash' }

      # old_flash store the flash we get from req, will user for current action
      @old_flash = cookie_data ? JSON.parse(cookie_data.value) : {}
      # new_flash store the new flash that supposed to be used in the next action
      @new_flash = {}
    end

    def [](key)
      if @flash_now.new_flash.has_key?(key.to_s)
        return @flash_now.new_flash.delete(key.to_s)
      end
      @old_flash[key.to_s]
    end

    def []=(key, val)
      @new_flash[key.to_s] = val
    end

    def now
      @flash_now ||= Flash.new(@req)
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flashes(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash', @new_flash.to_json)
    end
  end
end

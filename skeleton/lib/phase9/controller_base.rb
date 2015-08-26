require_relative '../phase8/controller_base'
require_relative './params'

module Phase9
  class ControllerBase < Phase8::ControllerBase
    # setup the controller
    def initialize(req, res, route_params = {})
      super(req, res, route_params)
      store_authenticity_token
    end

    def store_authenticity_token
      auth_cookie = req.cookies.find{ |cookie| cookie.name == 'authenticity_token' }
      @authenticity_token = auth_cookie ? auth_cookie.value : SecureRandom::urlsafe_base64
      res.cookies << WEBrick::Cookie.new('authenticity_token', authenticity_token)
    end

    # cookie we store for authenticity_token and params authenticity_token, what the diff?
    # how to distingush?


    # def invoke_action(name)
    #   if name.to_s == "create" || "update" || "destroy"
    #     unless params["authenticity_token"] &&
    #             params["authenticity_token"] == @authenticity_token
    #       self.send(name)
    #     end
    #   end
    # end



  end
end

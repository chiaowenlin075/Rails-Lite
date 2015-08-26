require_relative '../phase8/controller_base'
require_relative './params'

module Phase9
  class ControllerBase < Phase8::ControllerBase
    # setup the controller
    def initialize(req, res, route_params = {})
      super(req, res, route_params)
      store_authenticity_token
      # the cookie["authenticity_token"] is a string, no need to parse
      @authenticity_token = req.cookies.find{ |cookie| cookie.name == 'authenticity_token' }.value
    end

    def store_authenticity_token
      res.cookies << WEBrick::Cookie.new('authenticity_token', SecureRandom::urlsafe_base64(88))
    end

    # The two things you need to compare to prevent CSRF are BOTH from req!
    # The token we set --> req.cookies (Everytime, we set new token, and send that to res.cookies)
    # The token belongs to form --> req.body --> params

    def invoke_action(action_name)
      # only 'post' action need to check CSRF attack
      if ["create", "update", "destroy"].include?(action_name.to_s.downcase)
        if params["authenticity_token"] &&
            params["authenticity_token"] == @authenticity_token
          self.send(action_name)
        else
          raise CSRFAttackError
        end
      end

      render("#{name.to_s}.html.erb") unless already_built_response?
    end

  end
end

class CSRFAttackError < StandardError
end

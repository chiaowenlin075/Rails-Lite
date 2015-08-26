require_relative '../phase8/controller_base'

module Phase9
  class ControllerBase < Phase8::ControllerBase
    # setup the controller
    def initialize(req, res, route_params = {})
      super(req, res, route_params)
      store_authenticity_token
      # the cookie["authenticity_token"] is a string, no need to parse
      @authenticity_token = SecureRandom::urlsafe_base64(88)
      @protected = false
    end

    # decide whether actions are protected
    def protect_from_forgery(protect)
      @protected = protect
    end

    # store for checking in the next action
    def store_authenticity_token
      res.cookies << WEBrick::Cookie.new('authenticity_token', @authenticity_token)
    end

    # generate authenticity token for forms
    def form_authenticity_token
      @authenticity_token
    end

    # the safe authenticity_token obtained from req.cookies
    def safe_authenticity_token
      req.cookies.find{ |cookie| cookie.name == 'authenticity_token' }.value
    end

    # The two things you need to compare to prevent CSRF are BOTH from req!
    # The token we set --> req.cookies (Everytime, we set new token, and send that to res.cookies)
    # The token belongs to form --> req.body --> params
    def invoke_action(action_name)
      # only 'post' action need to check CSRF attack
      if ["create", "update", "destroy"].include?(action_name.to_s.downcase) && @protected
        unless params["authenticity_token"] &&
            params["authenticity_token"] == safe_authenticity_token
          raise CSRFAttackError
        end
      end
      self.send(action_name)
      render(action_name.to_s) unless already_built_response?
    end

    # let render capable of taking optional hash
    def render(template_name, opts = {})
      b = binding # set local variables for opts elements that can be use in the template
      opts.each { |k,v| b.local_variable_set(k.to_s, v) }

      controller_name = self.class.to_s.underscore
      file_path = "views/#{controller_name}/#{template_name}.html.erb"
      erb = ERB.new(File.read(file_path)).result(b)
      render_content(erb, "text/html")
    end

  end
end

class CSRFAttackError < StandardError
end

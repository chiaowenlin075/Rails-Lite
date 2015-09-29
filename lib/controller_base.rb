require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

require_relative './session'
require_relative './params'
require_relative './flash'
require_relative './url_helpers'

class ControllerBase
  extend UrlHelpers
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @already_built_response == false
    @params = Params.new(req, route_params)
    @authenticity_token = SecureRandom::urlsafe_base64(88)
    @protected = false
    store_authenticity_token
    self.class.define_url_helpers
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise if already_built_response?
    res.header["location"] = url
    res.status = 302
    session.store_session(res)
    flash.store_flash(res)
    @already_built_response = true
  end

  def render_content(content, content_type)
    raise if already_built_response?
    res.content_type = content_type
    res.body = content
    session.store_session(res)
    flash.store_flash(res)
    @already_built_response = true
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    file_path = "views/#{controller_name}/#{template_name}.html.erb"
    erb = ERB.new(File.read(file_path)).result(binding)
    render_content(erb, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  # decide whether actions are protected
  def protect_from_forgery(protect)
    @protected = protect
  end

  # store for checking in the next action
  def store_authenticity_token
    res.cookies << WEBrick::Cookie.new('authenticity_token', @authenticity_token)
  end

  def form_authenticity_token
    @authenticity_token
  end

  # the safe authenticity_token obtained from req.cookies
  def safe_authenticity_token
    req.cookies.find{ |cookie| cookie.name == 'authenticity_token' }.value
  end

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

  # render for partial which can take in optional variables
  def render_partial(template_name, opts = {})
    b = binding
    opts.each { |k,v| b.local_variable_set(k.to_s, v) }

    controller_name = self.class.to_s.underscore
    file_path = "views/#{controller_name}/#{template_name}.html.erb"
    erb = ERB.new(File.read(file_path)).result(b)
    render_content(erb, "text/html")
  end

end

class CSRFAttackError < StandardError
end

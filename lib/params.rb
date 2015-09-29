require 'uri'

module Phase5
  class Params
    def initialize(req, route_params = {})
      @params = route_params
      @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
      @params.merge!(parse_www_encoded_form(req.body)) if req.body
    end

    def [](key)
      @params[key.to_s] || @params[key.to_sym]
    end

    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    def parse_www_encoded_form(www_encoded_form)
      params_ary = URI::decode_www_form(www_encoded_form)
      result = {}

      params_ary.each do |params_key, value|
        keys = parse_key(params_key)
        sub_result = result
        keys.each_with_index do |key, idx|
          if idx == keys.size - 1
            sub_result[key] = value
          else
            sub_result[key] ||= {}
            sub_result = sub_result[key]
          end
        end
      end

      return result
    end

    def parse_key(key)
      key.split(/\[|\]\[|\]/)
    end
  end
end

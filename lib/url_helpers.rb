module UrlHelpers
  def resource_name
    /(\w+)Controller/.match(self.to_s)[1].downcase if /(\w+)Controller/.match(self.to_s)
  end

  def singular_name
    resource_name[0...(resource_name.length) -1] if resource_name
  end

  # call this in ControllerBase#initialize to make url_helpers
  def define_url_helpers
    self.instance_eval{
      define_index_url;
      define_new_url;
      define_show_url;
      define_edit_url
    }
  end

  def define_index_url
    define_method("#{resource_name}_url") do
     "#{self.class.resource_name}/"
    end
  end

  def define_new_url
    define_method("new_#{singular_name}_url") do
     "#{self.class.resource_name}/new"
    end
  end

  def define_show_url
    define_method("#{singular_name}_url") do |arg|
      raise ArgumentError unless arg.to_s =~ /^\d+$/ || arg.respond_to?(:id)

      if arg.to_s =~ /^\d+$/
        id = /^\d+$/.match(arg.to_s)[0]
      elsif arg.respond_to?(:id)
        id = arg.id
      end
     "#{self.class.resource_name}/#{id}"
    end
  end

  def define_edit_url
    define_method("edit_#{singular_name}_url") do |arg|
      raise ArgumentError unless arg.to_s =~ /^\d+$/ || arg.respond_to?(:id)

      if arg.to_s =~ /^\d+$/
        id = /^\d+$/.match(arg.to_s)[0]
      elsif arg.respond_to?(:id)
        id = arg.id
      end
     "#{self.class.resource_name}/#{id}/edit"
    end
  end

end

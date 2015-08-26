module ViewHelpers
  def link_to(show_text, url, opts = {})
    "<a href=\"#{url}\">#{show_text}</a>"
  end

  def button_to(show_text, url, opts = {})
    if opts.has_key?(:method)

    end
  end

end

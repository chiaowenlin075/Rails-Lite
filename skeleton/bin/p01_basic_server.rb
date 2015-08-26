require 'webrick'
require 'byebug'
require 'json'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new(:Port => 3000)

server.mount_proc("/") do |request, response|
  response.cookies << WEBrick::Cookie.new("cat_session", { "name" => "Sennacy"}.to_json )
  # byebug
  response.content_type = "text/text"
  response.body = request.path
  # response.body = "<h1><script>#{request.query}</script></h1>"
end


trap('INT') do
  server.shutdown
end

server.start

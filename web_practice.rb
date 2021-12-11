require 'webrick'

config ={
  :Port => 8099,
  :DocumentRoot => '.'
}

WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)

server = WEBrick::HTTPServer.new(config)

server.config[:MimeTypes]["erb"] = "text/html"

server.mount_proc("/testprog") do |req, res|
  res.body << "<html><body><p>リクエストのパスは＃{req.path}でした。</p></body></html>"
end

trap(:INT) do
  server.shutdown
end

server.start

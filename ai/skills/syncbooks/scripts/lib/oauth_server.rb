# frozen_string_literal: true

require "webrick"

module SyncBooks
  module OAuthServer
    REDIRECT_URI = "http://localhost:8080/callback"

    class << self
      # Start a temporary server and wait for OAuth callback
      # Returns the authorization code or nil on timeout
      def wait_for_callback(timeout: 300)
        code = nil
        server = WEBrick::HTTPServer.new(
          Port: 8080,
          Logger: WEBrick::Log.new(File::NULL),
          AccessLog: []
        )

        server.mount_proc "/callback" do |req, res|
          code = req.query["code"]
          res.content_type = "text/html"
          res.body = success_html
          server.shutdown
        end

        # Timeout thread
        Thread.new do
          sleep timeout
          server.shutdown if server.status == :Running
        end

        server.start
        code
      end

      private

      def success_html
        <<~HTML
          <!DOCTYPE html>
          <html>
            <head><title>Authorization Successful</title></head>
            <body style="font-family: sans-serif; text-align: center; padding: 50px;">
              <h1 style="color: #28a745;">Authorization Successful!</h1>
              <p>You can close this window and return to the terminal.</p>
            </body>
          </html>
        HTML
      end
    end
  end
end

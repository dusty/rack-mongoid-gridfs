require 'time'
require 'mongoid-grid_fs'
module Rack
  class MongoidGridFS

    def initialize(app,opts={})
      @prefix = opts[:prefix].gsub(/^\//, '') || 'grid'
      @cache  = opts[:cache] || 'max-age=0, private, must-revalidate'
      @app = app
    end

    ##
    # Strip the _id out of the path.  This allows the user to send something
    # like /#{prefix}/4ba69fde8c8f369a6e000003.jpg to find the file
    # with an id of 4ba69fde8c8f369a6e000003.
    def call(env)
      if env['PATH_INFO'] =~ %r{^/#{@prefix}/(\w+).*$}
        @env = env
        grid_request($1)
      else
        @app.call(env)
      end
    end

    ##
    # Get file from GridFS or return a 404
    def grid_request(id)
      begin
        file = ::Mongoid::GridFS.get(id)
        headers = {
          'ETag' => file.md5,
          'Last-Modified' => file.uploadDate.httpdate,
          'Cache-Control' => @cache
        }
        if not_modified?(file.md5, file.uploadDate)
          [304, headers, ['Not Modified']]
        else
          [200, headers.update('Content-Type' => file.contentType), [file.data]]
        end
      rescue ::Mongoid::Errors::DocumentNotFound
        [404, {'Content-Type' => 'text/plain'}, ['File not found.']]
      rescue StandardError => e
        [500, {'Content-Type' => 'text/plain'}, ['An error occured.']]
      end
    end

    private

    def not_modified?(etag,last_modified)
      none_match     = @env['HTTP_IF_NONE_MATCH']
      modified_since = @env['HTTP_IF_MODIFIED_SINCE']
      if none_match
        none_match == etag
      elsif modified_since
        # ignore usec
        (Time.rfc2822(modified_since).to_i >= last_modified.to_i) rescue false
      else
        false
      end
    end
  end
end

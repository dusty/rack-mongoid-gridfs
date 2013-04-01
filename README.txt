Rack::Mongoid::Grid

  Rack::Mongoid::Grid is used to serve a GridFS file from rack when using the mongoid-grid_fs gem.


Installation

  # add to bundler
  gem 'rack-mongoid-gridfs'

  # include in your app
  require 'rack/mongoid-gridfs'

Prefix

  Defines the mount-point to intercept rack requests.  The ID of the GridFS object is parsed after the
  mount point to search for the file. eg: /#{prefix}/#{grid_id}/unused.jpg

  The default prefix is 'grid', you may pass anything else to the :prefix option to change that.

  eg:
  :prefix => 'gridfs' # /gridfs/4ba69fde8c8f369a6e000003/unused.jpg
  :prefix => 'assets' # /assets/4ba69fde8c8f369a6e000003/unused.jpg


Cache Control

  The default cache control is "Cache-Control: max-age=0, private, must-revalidate"
  You may send any Cache-Control string in the :cache option to override the default.

  eg:
  :cache => 'no-cache, no-store'                    # 'Cache-Control: no-cache, no-store'
  :cache => 'max-age=300, private, must-revalidate' # 'Cache-Control: max-age=300, private, must-revalidate'


Usage

  # sinatra app
  use Rack::Grid, {
    :prefix => 'grid',
    :cache  => "max-age=300, private, must-revalidate"
  }


  # view.erb
  <img src="/grid/4ba69fde8c8f369a6e000003/filename.jpg" alt="My Image" />

Gem::Specification.new do |s|
  s.name = "rack-mongoid-gridfs"
  s.version = "0.0.1"
  s.author = "Dusty Doris"
  s.email = "github@dusty.name"
  s.homepage = "http://github.com/dusty/rack-mongoid-gridfs"
  s.platform = Gem::Platform::RUBY
  s.summary = "Rack helper for presenting MongoDB GridFS Files using mongoid-grid_fs"
  s.description = "Rack helper for presenting MongoDB GridFS Files using mongoid-grid_fs"
  s.files = [
    "README.txt",
    "lib/rack/mongoid-gridfs.rb",
    "test/test-rack-mongoid-gridfs.rb"
  ]
  s.extra_rdoc_files = ["README.txt"]
  s.add_dependency('mongoid-grid_fs')
  s.rubyforge_project = "none"
end

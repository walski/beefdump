require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "beefdump"
    gem.summary = %Q{A testbed for non-player character AI in role-playing games.}
    gem.description = %Q{A testbed for non-player character AI in role-playing games.}
    gem.email = "stillepost@gmail.com"
    gem.homepage = "http://github.com/walski/beefdump"
    gem.authors = ["Thorben Schröder"]
    gem.files = FileList['lib/**/*.rb']

    gem.add_dependency "xml-simple"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "beefdump #{version}"
  rdoc.rdoc_files.include('README*')
  # rdoc.rdoc_files.include('lib/**/*.rb')
end
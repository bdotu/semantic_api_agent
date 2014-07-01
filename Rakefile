# Todo: Change the path format
rake_tasks = Dir["lib/tasks/*.rake"]
rake_tasks = rake_tasks - ['lib/tasks/deploy_assets.rake', 'lib/tasks/jasmine.rake'] unless ['development', 'test'].include? ENV['RACK_ENV']
rake_tasks.each do |rakefile|
  load(File.expand_path(rakefile))
end
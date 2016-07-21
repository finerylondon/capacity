namespace :capacity do
  desc 'Run capacity load tester'
  task :run do
    Capacity::Run.ab
  end
end

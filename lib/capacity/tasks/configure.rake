namespace :capacity do
  desc 'Generate Capacity config file'
  task :configure do
    file = File.open(File.join(Capacity.root, 'lib/config/config.yml'), 'w+') do |f|
      f.puts "urls: #{ENV['urls'] || 'http://staging.finerylondon.com/'}"
      f.puts "runs: #{ENV['runs'] || 10}"
      f.puts "concurrency: #{ENV['conc'] || 10}"
      f.puts "num_requests: #{ENV['reqs'] || 100}"
    end
  end
end

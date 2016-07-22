namespace :capacity do
  desc 'Generate Capacity config file'
  task :configure do
    File.open(File.join(Capacity.root, '/lib/config/config.yml'), 'w+') do |f|
      f.puts "urls: #{ENV['urls'] || 'http://staging.finerylondon.com/'}"
      f.puts "runs: #{ENV['runs'] || 1}"
      f.puts "concurrency: #{ENV['conc'] || 10}"
      f.puts "num_requests: #{ENV['reqs'] || 100}"
    end
    Capacity::Logger.log(:info, 'New config is:')
    Capacity::Logger.log(:result, File.read(File.join(Capacity.root, '/lib/config/config.yml')).to_s)
  end
end

namespace :capacity do
  desc 'Run capacity load tester'
  task :run do
    opts = options_hash
    if opts.values.compact.size > 0
      update_options(opts)
      Capacity::CapConfig.load
    end
    Capacity::Run.ab
  end

  desc 'Generate Capacity config file'
  task :configure do
    opts = options_hash
    if opts.values.compact.size > 0
      update_options(opts)
    else
      create_config
    end
    Capacity::Logger.log(:info, 'New config is:')
    Capacity::Logger.log(:result, File.read(File.join(Capacity.root, '/lib/config/config.yml')).to_s)
  end

  def options_hash
    { urls: ENV['urls'], runs: ENV['runs'],
      conc: ENV['conc'], reqs: ENV['reqs'] }
  end

  def update_options(opts)
    file_path = File.join(Capacity.root, '/lib/config/config.yml')

    original_file = IO.readlines(file_path)

    new_file =
      ''.tap do |str|
        original_file.each do |line|
          opts.each do |k, v|
            if v
              key_name = long_key(k)
              if line.include?(key_name)
                str << "#{key_name}: #{v}\n"
              else
                str << line
              end
            else
              line
            end
          end
        end
      end

    if new_file.size
      file = File.open(file_path, 'w+')
      file.write(new_file)
      file.close
    end

    Capacity::CapConfig.load
  end

  def create_config
    File.open(File.join(Capacity.root, '/lib/config/config.yml'), 'w+') do |f|
      f.puts "urls: 'http://staging.finerylondon.com/'"
      f.puts 'runs: 1'
      f.puts 'concurrency: 10'
      f.puts 'num_requests: 100'
    end
    Capacity::CapConfig.load
  end

  def long_key(key)
    case key
    when :urls
      'urls'
    when :runs
      'runs'
    when :conc
      'concurrency'
    when :reqs
      'num_requests'
    end
  end
end

namespace :capacity do
  desc 'Run capacity load tester'
  task :run do
    opts = options_hash
    if opts.values.compact.size > 0
      Capacity::CapConfig.update_config(opts)
    end
    Capacity::Run.ab
  end

  desc 'Generate or update Capacity config file'
  task :configure do
    opts = options_hash
    if opts.values.compact.size > 0
      Capacity::CapConfig.update_config(opts)
    else
      Capacity::Logger.log(:info, 'Config file note found... creating')
      Capacity::CapConfig.create_default_config_file
      Capacity::CapConfig.load
    end
    Capacity::Logger.log(:info, 'New config is:')
    Capacity::Logger.log(
      :result,
      File.read(File.join(Capacity.root, '/lib/config/config.yml')).to_s
    )
  end

  def options_hash
    { urls: ENV['urls'], runs: ENV['runs'],
      conc: ENV['conc'], reqs: ENV['reqs'] }
  end

end

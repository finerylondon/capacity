namespace :capacity do
  desc "Run load tests against ALL page sets"
  task :all do
    if Capacity::Config.page_sets.length == 0
      Capacity::Logger.log(:failure, "No page sets defined. Nothing to do")
    end

    Capacity::Config.page_sets.keys.each do |page_set_key|
      Capacity::Tester.test(Capacity::Config.page_sets[page_set_key])
    end
  end
end

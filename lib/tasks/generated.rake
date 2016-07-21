# namespace :capacity do
#
#   Capacity::Config.page_sets.keys.each do |page_set_key|
#     unless Rake::Task.task_defined? page_set_key
#       desc "Run load tests for #{page_set_key}"
#       task page_set_key do
#         Capacity::Tester.test(Capacity::Config.page_sets[page_set_key])
#       end
#     end
#   end
# end

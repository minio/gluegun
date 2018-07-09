require "bundler/gem_tasks"
task :default => [:clean, :build]

task :clean do
    puts "Cleaning up generated docs"
    sh "rm -rf docs"
    sh "rm -f lib/_sidebar.erb"
end

task :build do
    sh "yarn && gulp"
    sh "gem build gluegun.gemspec"
    puts "DONE. To install gluegun, run `gem install gluegun`"
end

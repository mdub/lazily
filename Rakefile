require "rake"

require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["--format", "doc"]
end

task "default" => "spec"

desc "Generate documentation"
task(:doc) { sh "yard" }

desc "Generate documentation incrementally"
task(:redoc) { sh "yard -c" }

# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'Run unit and integration tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/tests/{integration,unit}/**/*_spec.rb'
  t.warning = false
end

desc 'Run acceptance, unit and integration tests'
Rake::TestTask.new(:spec_all) do |t|
  t.pattern = 'spec/tests/**/*_spec.rb'
  t.warning = false
end

desc 'Keep rerunning unit/integration tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

# NOTE: run `rake run:test` in another process
desc 'Run acceptance tests'
Rake::TestTask.new(:spec_accept) do |t|
  t.pattern = 'spec/tests/acceptance/*_spec.rb'
  t.warning = false
end

desc 'Keep restarting web app upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment' # load config info
    require_relative 'spec/helpers/database_helper'

    def app() = HobbyCatcher::App
  end

  desc 'Run migrations'
  task migrate: :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    puts "Need to run 'HobbyCatcher::InitializeDatabase::Create.load'"
    Sequel::Migrator.run(app.DB, 'app/infrastructure/database/migrations')
  end

  desc 'Wipe records from all tables'
  task wipe: :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end

    require_relative 'app/infrastructure/database/init'
    require_relative 'spec/helpers/database_helper'
    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file (set correct RACK_ENV)'
  task drop: :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end

    FileUtils.rm(app.config.DB_FILENAME)
    puts "Deleted #{app.config.DB_FILENAME}"
  end
end

namespace :repos do
  task :config do
    require_relative 'config/environment' # load config info
    def app() = HobbyCatcher::App
  end

  desc 'Create director for repo store'
  task create: :config do
    puts `mkdir #{app.config.REPOSTORE_PATH}`
  end

  desc 'Delete cloned repos in repo store'
  task wipe: :config do
    sh "rm -rf #{app.config.REPOSTORE_PATH}/*" do |ok, _|
      puts(ok ? 'Cloned repos deleted' : 'Could not delete cloned repos')
    end
  end

  desc 'List cloned repos in repo store'
  task list: :config do
    puts `ls #{app.config.REPOSTORE_PATH}`
  end
end
# namespace :repos do
#   task :config do
#     require_relative 'config/environment' # load config info
#     def app() = HobbyCatcher::App
#   end

#   desc 'Create director for repo store'
#   task :create => :config do
#     puts `mkdir #{app.config.REPOSTORE_PATH}`
#   end

#   desc 'Delete cloned repos in repo store'
#   task :wipe => :config do
#     sh "rm -rf #{app.config.REPOSTORE_PATH}/*" do |ok, _|
#       puts(ok ? 'Cloned repos deleted' : 'Could not delete cloned repos')
#     end
#   end

#   desc 'List cloned repos in repo store'
#   task :list => :config do
#     puts `ls #{app.config.REPOSTORE_PATH}`
#   end
# end

desc 'Run application console'
task :console do
  sh 'pry -r ./init'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'run all static-analysis quality checks'
  task all: %i[rubocop reek flog]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog -m #{only_app}"
  end
end

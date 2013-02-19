namespace :casper do

  desc "Prepare the test database for casper"
  task :prepare => :environment do
    ["db:test:prepare"].each do |t|
      Rake::Task[t].invoke
    end
  end

  desc "Clear the database of all existing records"
  task :clear => :environment do
    puts "Deleting existing messages ..."
    Message.delete_all
  end

  desc "Run the casper test suite"
  task :run => [:environment, :clear] do
    ["casper:home", "casper:create_message", "casper:create_and_read_message", "casper:create_and_read_utf8"].each do |t|
      Rake::Task[t].execute
    end
  end

  desc "Run the casper home tests"
  task :home => [:environment, :clear] do
    test_path = Rails.root.join('test', 'casper', 'tests', 'home.coffee')
    system("casperjs test #{test_path}")
  end

  desc "Run the casper create message tests"
  task :create_message => [:environment, :clear] do
    #Message.delete_all
    test_path = Rails.root.join('test', 'casper', 'tests', 'create_message.coffee')
    coffelint_config = Rails.root.join('test', 'casper', 'coffeelint.json')
    lint_cmd = "coffeelint -f #{coffelint_config} #{test_path}"
    system(lint_cmd)
    system("casperjs test --log-level=debug #{test_path}")
  end

  desc "Run the casper create and read message tests"
  task :create_and_read_message => [:environment, :clear] do
    #Message.delete_all
    test_path = Rails.root.join('test', 'casper', 'tests', 'create_and_read_message.coffee')
    system("casperjs test --log-level=debug #{test_path}")
  end

  desc "Run the casper create and read UTF8 message tests"
  task :create_and_read_utf8 => [:environment, :clear] do
    #Message.delete_all
    test_path = Rails.root.join('test', 'casper', 'tests', 'create_and_read_utf8.coffee')
    system("casperjs test --log-level=debug #{test_path}")
  end

end

# Create a default rake task for "rake casper" to run all the tests
task :casper => ["casper:run"]
# -*- coding: utf-8 -*-
require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'

task :default => :migrate

desc "Migrate the database through scripts in 'migrate'. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  @logger = Logger.new STDOUT
  RAILS_ENV = (ENV['RAILS_ENV'] ||= 'development')
  dbconfig = YAML::load(File.open('database.yml'))[RAILS_ENV]
  ActiveRecord::Base.establish_connection(dbconfig)
  
  # Enable diagnostic logging to help debugging.
  ActiveRecord::Base.logger = @logger
  ActiveRecord::Base.set_primary_key "Id"

end

task :console do
  sh "irb -rubygems -I lib -r lib/console"
end

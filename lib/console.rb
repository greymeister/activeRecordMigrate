require 'active_record'

ENV['RAILS_ENV'].nil? ? RAILS_ENV = 'development' : RAILS_ENV = ENV['RAILS_ENV']

@logger = Logger.new STDOUT
config = YAML::load(IO.read('db/database.yml'))
ActiveRecord::Base.logger = @logger
ActiveRecord::Base.logger.level = Logger::ERROR
#config[RAILS_ENV]["database"] = config[RAILS_ENV]["database"] if config[RAILS_ENV]["adapter"] == "sqlite3" and RAILS_ENV == 'development'
ActiveRecord::Migration.verbose = true
ActiveRecord::Base.configurations = config
ActiveRecord::Base.establish_connection(config[RAILS_ENV])
#ActiveRecord::Base.colorize_logging = false
RAILS_ROOT = Dir.pwd

excluded_tables = %w{schema_migrations sqlite_sequence sysdiagrams}

data = []

ActiveRecord::Base.connection.tables.reject{|t| excluded_tables.include? t}.each do |table|
  code = "class #{table.camelize} < ActiveRecord::Base; set_table_name \"#{table}\"; set_primary_key \"Id\"; "
  eval "#{code} end"
  has_manys = []
  table.camelize.constantize.columns.map{|m|m.name}.select{|m|m.ends_with? "_id"}.each do |col|
    col = col.gsub(/_id/,"")
    code << "belongs_to :#{col};"
    has_manys << col
  end
  code << "end"
  eval code

  has_manys.each do |hm|
    code = "class #{hm.camelize} < ActiveRecord::Base;"
    code << "has_many :#{table.tableize}, :class_name => '#{table}', :foreign_key => '#{hm}_id', :primary_key => 'Id';"
    code << "end\n"
    eval code
  end
end

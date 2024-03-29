require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/worklog.db")



class WorklogEntry
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :date_performed, DateTime

  belongs_to :work_type
  belongs_to :work_to_do
  
end

class WorkType
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true

  has n, :worklog_entries
  
end

class WorkToDo
  include DataMapper::Resource

  property :id, Serial
  property :name, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :description, Text
  property :star_number, Text
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :worklog_entries

  def self.tasks_worked(filter = {})
    all(filter).select{ |t| t.worklog_entries.count > 0 }
  end
end
DataMapper.finalize.auto_upgrade!
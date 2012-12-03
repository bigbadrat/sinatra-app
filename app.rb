require 'rubygems'
require 'sinatra'
require 'haml'
require 'maruku'
require './model'


def render_partial(page, options={})
  haml page.to_sym, options.merge!(:layout => false)
end

set :public_folder, File.dirname(__FILE__) + '/assets'


get '/' do
  @notes = WorklogEntry.all :order => :id.asc  
  @todos = WorkToDo.all
  haml :home  
end 

get '/about' do
	"the aboot page"
end

#The main handler for the "add" action form
get '/add/:thing' do
  @work_to_do = WorkToDo.all
  if params[:thing] == "entry" 
    @work_types = WorkType.all    
    today = Time.now
    @time_list = [today]
    1.upto(25).each do |x| 
      @time_list.push( today - 60*60*25*x) 
    end
  	haml :form_entry
  elsif params[:thing] == "todo"
    @props = ["name", "star_number"]
    @items = WorkToDo.all
    haml :form_todo
  elsif params[:thing] == "type"
    @types = WorkType.all
    @props = WorkType.properties
    haml :form_type
  end
end

#The actual handler for the "add" action that actually adds stuff
post '/add/:thing' do
  if params[:thing] == "entry"
    puts "adding a new entry!"
    puts params
    new_item = WorklogEntry.new
    new_item.content = params[:content]
    new_item.work_type = WorkType.get( params[:type] )
    new_item.work_to_do = WorkToDo.get( params[:todo] )
    puts new_item.content
    puts new_item.work_type.id
    puts new_item.work_to_do.id
    puts "all looks fine"
    puts new_item.save
  elsif params[:thing] == "todo"
    new_item = WorkToDo.new
    new_item.name = params[:name]
    new_item.description = params[:description]
    new_item.star_number = params[:star_number]
    new_item.save
  end
  redirect to("/")
end

get '/list/:thing' do
  
  if params[:thing] == "todo" 
    @title = "Work to do"
    @props = WorkToDo.properties
    @items = WorkToDo.all
    haml :simple_list 
  elsif params[:thing] == "type" 
    @title = "Work type"
    @props = WorkType.properties
    @items = WorkType.all
    haml :simple_list 
  elsif params[:thing] == "entry" 
    @title = "Work entry"
    @props = WorklogEntry.properties
    @items = WorklogEntry.all
    haml :simple_list 
  end
end
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

get '/add/:thing' do
  @work_to_do = WorkToDo.all
  if params[:thing] == "entry" 
    @work_types = WorkType.all    
    today = Time.now
    @time_list = [today]
    1.upto(25).each do |x| @time_list.push( today - 60*60*25*x) end

  	haml :form_entry

  elsif params[:thing] == "todo"
    haml :form_todo
  end
end

post '/add/:thing' do
  if params[:thing] == "entry"
    wl = WorklogEntry.new
    wl.content = params[:title]
    wl.work_type = WorkType.get( params[:type] )
    wl.work_to_do = WorkToDo.get( params[:todo] )
    wl.save    
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
# Implement the new web-based CRM here.
# Do NOT copy the CRM class from the old crm assignment, as it won't work at all for the web-based version!
# You'll have to implement it from scratch.
require 'sinatra'
require_relative 'contact'

# Fake data
# Contact.create('Marty', 'McFly', 'marty@mcfly.com', 'Chicken')
# Contact.create('George', 'McFly', 'george@mcfly.com', 'Dad')
# Contact.create('Lorraine', 'McFly', 'lorraine@mcfly.com', 'Mom')
# Contact.create('Biff', 'Tannen', 'biff@Tannen.com', 'Casino Mogul')
# Contact.create('Doc', 'Brown', 'doc@brown.com', 'Blacksmith')

get '/' do
  @crm_app_name = "Quantum Duck's CRM"
  erb :index
end

get '/about' do
  @crm_app_name = "Quantum Duck's CRM"
  erb :about
end

get '/contacts' do
  @crm_app_name = "Quantum Duck's CRM"
  # The homepage is now the same as the old contacts list page
  erb :index
end

get '/new' do
  @crm_app_name = "Quantum Duck's CRM"
  erb :new_contact
end

post '/contacts' do
  contact = Contact.create(
    first_name: params[:first_name],
    last_name:  params[:last_name],
    email:      params[:email],
    note:       params[:note]
  )
  redirect to('/contacts')
end

get '/contacts/:id' do
  @crm_app_name = "Quantum Duck's CRM"
  puts params
  idnum = params[:id].to_i
  contact = Contact.find(idnum)
  puts
  puts contact.class
  puts
  # Note: the @contact_info hash was used because I had difficulty passing the
  # @contact object into the html parser without raising type errors.
  if contact
    @contact_info = {name: contact.full_name, email: contact.email, note: contact.note, index: idnum}
    erb :contact_template
  else
    puts "why am I here?"
    raise Sinatra::NotFound
  end

  erb :contact_template
end

get '/contacts/:id/edit' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end

get '/contacts/:id/delete' do
  idnum = params[:id].to_i
  contact = Contact.find(idnum)
  # Note: the @contact_info hash was used because I had difficulty passing the
  # @contact object into the html parser without raising type errors.
  if contact
    @contact_info = {name: contact.full_name, email: contact.email, note: contact.note, index: idnum}
    erb :delete_template
  else
    puts "why am I here?"
    raise Sinatra::NotFound
  end

end

put '/contacts/:id' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]
    redirect to("/contacts/#{params[:id]}")
  else
    raise Sinatra::NotFound
  end
end

delete '/contacts/:id' do
  @contact = Contact.find(params[:id].to_i)
  if @contact
    @contact.delete
    redirect to('/')
  else
    raise Sinatra::NotFound
  end
end

after do
  ActiveRecord::Base.connection.close
end

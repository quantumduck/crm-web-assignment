# Implement the new web-based CRM here.
# Do NOT copy the CRM class from the old crm assignment, as it won't work at all for the web-based version!
# You'll have to implement it from scratch.
require 'sinatra'
require_relative 'contact'

# Fake data
Contact.create('Mark', 'Zuckerberg', 'mark@facebook.com', 'CEO')
Contact.create('Sergey', 'Brin', 'sergey@google.com', 'Co-Founder')
Contact.create('Steve', 'Jobs', 'steve@apple.com', 'Visionary')

get '/' do
  @crm_app_name = "Bitmaker's CRM"
  erb :index
end

get '/contacts' do
  @crm_app_name = "Bitmaker's CRM"
  erb :contacts
end

get '/new' do
  @crm_app_name = "Bitmaker's CRM"
  erb :new_contact
end

post '/contacts' do
  Contact.create(params[:first_name], params[:last_name], params[:email], params[:note])
  redirect to('/contacts')
end

get '/contacts/:id' do
  @crm_app_name = "Bitmaker's CRM"
  puts params
  @contact = Contact.find(params[:id].to_i)
  puts @contact.full_name
  erb :contact_template
end

post '/contacts/:id' do
  contact = Contact.find(params[:id].to_i)
  contact.delete
  redirect to('/contacts')
end

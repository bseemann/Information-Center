require 'rubygems'
require 'mechanize'
require 'dropbox_sdk'
require 'uri'
require 'net/http'
require 'json'


class AuthenticationController < ApplicationController
# Class that control the Authenticatiom system and its views
  layout 'login', :only => [:login]


  APP_KEY = '1g9mnjegs1l7j3m'
  APP_SECRET = 'glhnoqva181wmpa'

  #def login

  #end

#Method that controls the welcome view
# @param email [String] receives the params from the form on login
# @param senha [String] receives the params from the form on login
  def welcome(email = params[:my_email], senha = params[:my_password])
    @email = email #Just for test
    url = 'https://auth.aiesec.org/users/sign_in' #Store the url for authenticate at EXPA
    agent = Mechanize.new  #Initialize an instance to start to work with mechanize
    page = agent.get(url)
    aiesec_form = page.form() #Selects the form on the page by its name. However this form doens't have a name
    aiesec_form.field_with(:name => 'user[email]').value = email #Set the email field with the args of this function
    aiesec_form.field_with(:name => 'user[password]').value = senha #Set the password field with the seccond arg of this function
    page = agent.submit(aiesec_form, aiesec_form.buttons.first) #submit the form

    if page.code.to_s == '200' #Verify if the page's code is 200, which means its all right
      cj = agent.cookie_jar  #Store the cookie at cj variable
      if cj.jar['experience.aiesec.org'] == nil  #Verify if inside the cookie exist an experience.aiesec.org
        redirect_to(:action => "error") #If its nil redirect to the error page
      else
        #$token = cj.jar['experience.aiesec.org']['/']["expa_token"].value[44,64] #Take the token code for API. First version
        $token = cj.jar['experience.aiesec.org']['/']["expa_token"].value #take the expa. Working on November 9, 2015


      end
    end

    @request = "https://gis-api.aiesec.org:443/v1/current_person.json?access_token=#{$token}"
    resp = Net::HTTP.get_response(URI.parse(@request))
    data = resp.body
    @current_person = JSON.parse(data)

    if Owner.where(:email => @email).blank?
      $user = Owner.new(:name => @current_person['person']['full_name'], :email => @email )
      $user.save
      $user = $user.name
    else
      $user = Owner.where(email: @email).pluck(:name)[0]
    end

  end


  def error

  end
  # Method that creates arrays of files and directories to list on the view files
  #@param

  def navigation_params (content=params[:parent_id], upload=params[:file], new_folder_name=params[:folder_name], files_array=params[:fil], rename=[params[:rename_new_name], params[:rename_old_name]], move= [params[:move_from], params[:move_to]], page=params[:page])

    #Store the path into a global variable because this variable is necessary in others methods.
    if content == nil
      $root = "/"
    else
      $root = content
    end
    #Takes the current page sent through the form at the view's end
    if $page == nil
      $page = 1
    elsif $page != page
      $page = page.to_i
    end
# Create new folder if the user submited the form to do it
    unless new_folder_name == nil
      @new_folder = new_folder_name
    end
    $client = DropboxClient.new("siZpe-o98xoAAAAAAAAAl9HJEsrdDz0EPFebqJHr-oZryn0TL2aNhcGVSQvEjm71")
    #Upload a file if the user submited the form to do it and added a file to the upload form
    unless upload == nil || files_array.include?("#{upload.original_filename}")
      #@dude = upload.original_filename
      file = open(upload.path())
      response = $client.put_file("#{$root}/#{upload.original_filename}", file)
      #Save a record with the data about who uploaded the file
      record = Archive.new
      record.name = upload.original_filename
      record.owner = $user
      record.save
    end
    #Rename the File if the user submited the form to do it
    unless rename[0] == nil
      $client.file_move("#{$root}/#{rename[1]}","#{$root}/#{rename[0]}")
    end
#Create new folder if the user submited the form to do it
    unless @new_folder == nil
      $client.file_create_folder("#{$root}/#{@new_folder}")
    end

#Move File if the user submited the form to do it
    unless move[0] == nil || move[1] == nil
      if move[1] == '..'
        $client.file_move("#{move[0]}" , "#{$root.split('/')[1...-1].join}/#{move[0].split("/").last}" )
      else
        $client.file_move("#{move[0]}","#{$root}/#{move[1].strip}/#{move[0].split("/").last}")
      end
    end

#Stores the metadata's content to iterate later and create an array for files and another for directories
    $root_metadata = $client.metadata($root)['contents']
    #Creates the variables to store the arrays
    $files = Array.new
    $directories = Array.new
    $file_modification = Hash.new
    $file_creation = Hash.new

# iterate and create an array for files, for directories, creation and modification.
    $root_metadata.each do |hash|
      if hash["is_dir"] == false then
        $files << hash["path"]
        #Create a hash whose key values are the name of archives and the properly values the last modification time
        $file_modification[$files.last] = hash['modified']
        #Create a hash whose key values are the name of archives and the properly values the last modification time
        $file_creation[$files.last] = hash['client_mtime']
      else
        $directories << hash["path"]
      end
    end
    $show=($directories+$files)
    $offset = 10
    $pages = if $show.length % $offset == 0 then
              ($show.length/$offset)
            else
              ($show.length/$offset)+1
            end

    redirect_to authentication_files_path

  end


  #def files

  #end

end

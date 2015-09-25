require 'rubygems'
require 'mechanize'
require 'dropbox_sdk'

class AuthenticationController < ApplicationController
# Class that control the Authenticatiom system and its views



  APP_KEY = '1g9mnjegs1l7j3m'
  APP_SECRET = 'glhnoqva181wmpa'


  def login

  end

#Method that controls the welcome view
# @param email [String] receives the params from the form on login
# @param senha [String] receives the params from the form on login
  def welcome(email = params[:my_email], senha = params[:my_password])
    @email = email #Just for test
    url = 'https://auth.aiesec.org/users/sign_in' #Store the url for authenticate at EXPA
    agent = Mechanize.new #Initialize an instance to start to work with mechanize
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
        @token = cj.jar['experience.aiesec.org']['/']["aiesec_token"].value # Stores the cookie into an instance variable @token if the value of the cookie is not nil.
      end
    end
  end


  def error

  end
  # Method that creates arrays of files and directories to list on the view files
  #@param

  def navigation_params (content=params[:parent_id], upload=params[:file], new_folder_name=params[:folder_name], files_array=params[:fil], rename=[params[:rename_new_name], params[:rename_old_name]], move= [params[:move_from], params[:move_to]])
    $m = move
    unless content == nil
      $root = content
    end
    unless new_folder_name == nil
      @new_folder = new_folder_name
    end
    $client = DropboxClient.new("siZpe-o98xoAAAAAAAAAl9HJEsrdDz0EPFebqJHr-oZryn0TL2aNhcGVSQvEjm71")
    unless upload == nil || files_array.include?("#{upload.original_filename}")
      #@dude = upload.original_filename
      file = open(upload.path())
      response = $client.put_file("#{$root}/#{upload.original_filename}", file)
    end

    unless rename == nil
      $client.file_move("#{$root}/#{rename[1]}","#{$root}/#{rename[0]}")
    end

    unless @new_folder == nil
      $client.file_create_folder("#{$root}/#{@new_folder}")
    end

    unless move[0] == nil || move[1] == nil

      $client.file_move("#{move[0]}","#{$root}/#{move[1]}/#{move[0].split("/").last}")
    end

    @root_metadata = $client.metadata($root)['contents']
    #Creates the variables to store the arrays
    $files = Array.new
    $directories = Array.new
    $file_modification = Hash.new
    $file_creation = Hash.new

    @root_metadata.each do |hash|
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

    redirect_to authentication_files_path

  end


  def files

  end

end

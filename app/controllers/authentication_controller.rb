require 'rubygems'
require 'mechanize'
require 'dropbox_sdk'
require 'uri'
require 'net/http'
require 'json'

# @author Mauro Victor
class AuthenticationController < ApplicationController
# Class that control the Authenticatiom system and its views
  
  layout 'login', :only => [:login]
  
  include AuthenticationHelper #Use this module of helpers
  
  APP_KEY = '1g9mnjegs1l7j3m'
  APP_SECRET = 'glhnoqva181wmpa'

  

  def error

  end

  def login 
    if current_user
      #request the expa's current user data
      @request = "https://gis-api.aiesec.org:443/v1/current_person.json?access_token=#{session[:token]}"
      resp = Net::HTTP.get_response(URI.parse(@request))
      data = resp.body
      @current_person = JSON.parse(data)
      #Find the user on system
      @user = User.find_by_email(params[:my_email])
      redirect_to authentication_welcome_path
    else
      render 'login'
    end
  end


  # Takes the params for navigation 
  # @param content [String] path of the actual directory
  # @param upload[String] upload file to be uploaded
  # @param new_folder_name [String] name of the new folder name in case the user fulfilled a form to create a new one
  # @param files_array [Array] array of files to check if the file to be uploaded alaready exists
  # @param rename [Array] new and old name from the file that will be renamed
  # @param move [Array] Origin path and target path for the file will be moved
  # @param page [Number] Number of the page passed by the user through it's navigation
  # @param remove [String] Path of file to be removed on the request
  def navigation_params (content=params[:parent_id], upload=params[:file], new_folder_name=params[:folder_name], files_array=params[:fil], rename=[params[:rename_new_name], params[:rename_old_name]], move= [params[:move_from], params[:move_to]], page=params[:page], remove=params[:to_remove])

    #Store the path into a global variable because this variable is necessary in others methods.
    #If it is being requested by Arquivos's link set the root as "/"
    if request.get?
      session[:dbox_path] = "/"
    else
      session[:dbox_path] = content
    end
    #Takes the current page sent through the form at the view's end
    #If it is being requested by Arquivos's link set the page as 1
    if request.get?
      session[:page_number] = 1
    else
      session[:page_number] = page.to_i
    end
    # Create new folder if the user submited the form to do it
    unless new_folder_name == nil
      @new_folder = new_folder_name
    end

    #start the client from dropbox
    #still local variable because ain't no room for this in sessions or cookies
    $client = DropboxClient.new("siZpe-o98xoAAAAAAAAAl9HJEsrdDz0EPFebqJHr-oZryn0TL2aNhcGVSQvEjm71")
    
    #Upload a file if the user submited the form to do it and added a file to the upload form
    unless upload == nil || files_array.include?("#{upload.original_filename}")
      #@dude = upload.original_filename
      file = open(upload.path())
      response = $client.put_file("#{session[:dbox_path]}/#{upload.original_filename}", file)
      #Save a record with the data about who uploaded the file
      record = Archive.new
      record.name = upload.original_filename
      record.owner = current_user.name
      record.local_commitment = current_user.local_commitment
      record.save
    end
    #Rename the File if the user submited the form to do it
    unless rename[0] == nil
      $client.file_move("#{session[:dbox_path]}/#{rename[1]}","#{session[:dbox_path]}/#{rename[0]}")
    end
    #Create new folder if the user submited the form to do it
    unless @new_folder == nil
      $client.file_create_folder("#{session[:dbox_path]}/#{@new_folder}")
    end

    #Move File if the user submited the form to do it
    unless move[0] == nil || move[1] == nil
      if move[1] == '..'
        $client.file_move("#{move[0]}" , "#{session[:dbox_path].split('/')[1...-1].join}/#{move[0].split("/").last}" )
      else
        $client.file_move("#{move[0]}","#{session[:dbox_path]}/#{move[1].strip}/#{move[0].split("/").last}")
      end
    end

    unless remove == nil
      $client.file_delete(remove)
    end

    #Stores the metadata's content to iterate later and create an array for files and another for directories
    $root_metadata = $client.metadata(session[:dbox_path])['contents']

    #Creates the variables to store files and directories
    $files = Array.new
    $directories = Array.new


    # iterate and create an array for files, for directories, creation and modification.
    $root_metadata.each do |hash|
      if hash["is_dir"] == false then
        #Take all the attributes necessary to show the files informations [path, creation-time, modified-time, lenght, type]
        $files << [hash["path"], date_format(hash['client_mtime']), date_format(hash['modified']), unit(hash["bytes"]),get_type(hash["path"]), hash["revision"]]
        
      else
        $directories << hash["path"]
      end
    end
    
    $show=($directories+$files)

    #Organize the pages
    $offset = 10
    $pages = if $show.length % $offset == 0 then
              ($show.length/$offset)
            else
              ($show.length/$offset)+1
            end

    redirect_to authentication_files_path
    
  end

  def refresh
    root_metadata = $client.metadata(session[:dbox_path])['contents']
    root_metadata.each do |file|
      unless Archive.find_by_name(file['path'].split('/').last)
        record = Archive.new
        record.name = $root_metadata['path'].split('/').last
        record.path = $root_metadata['path']
        record.save
      end
    end
  end
  
  def upload(upload=params[:file], path=params[:parent_id])
    unless upload == nil || Archive.find_by_name("#{upload.original_filename}")
      file = open(upload.path())
      response = $client.put_file("#{session[:dbox_path]}/#{upload.original_filename}", file)
      #Save a record with the data about who uploaded the file
      record = Archive.new
      record.name = upload.original_filename
      record.owner = current_user.name
      record.local_commitment = current_user.local_commitment
      record.path = path
      record.save
    end
    
    redirect_to authentication_files_path
  end

  #def welcome
    
  #end

  def files
  end
  
  helper_method :current_user
  
  #define the current user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    return @current_user
  end

  def require_user
    redirect_to '/login' unless $current_user
  end
  
  
end

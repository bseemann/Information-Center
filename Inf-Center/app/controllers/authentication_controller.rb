require 'rubygems'
require 'mechanize'
require 'dropbox_sdk'
require 'uri'
require 'net/http'
require 'json'


class AuthenticationController < ApplicationController
# Class that control the Authenticatiom system and its views
  layout 'login', :only => [:login]
  include AuthenticationHelper #Use this module of helpers

  APP_KEY = '1g9mnjegs1l7j3m'
  APP_SECRET = 'glhnoqva181wmpa'

  #def login

  #end

#Method that controls the welcome view
# @param email [String] receives the params from the form on login
# @param senha [String] receives the params from the form on login



  def error

  end
  # Method that creates arrays of files and directories to list on the view files
    #@param

  def navigation_params (content=params[:parent_id], upload=params[:file], new_folder_name=params[:folder_name], files_array=params[:fil], rename=[params[:rename_new_name], params[:rename_old_name]], move= [params[:move_from], params[:move_to]], page=params[:page], remove=params[:to_remove])


    #Store the path into a global variable because this variable is necessary in others methods.
    #If it is being requested by Arquivos's link set the root as "/"
    if request.get?
      $root = "/"
    else
      $root = content
    end
    #Takes the current page sent through the form at the view's end
    #If it is being requested by Arquivos's link set the page as 1
    if request.get?
      $page = 1
    else
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
      record.owner = $user.name
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

    unless remove == nil
      $client.file_delete(remove)
    end

#Stores the metadata's content to iterate later and create an array for files and another for directories
    $root_metadata = $client.metadata($root)['contents']

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
    $offset = 10
    $pages = if $show.length % $offset == 0 then
              ($show.length/$offset)
            else
              ($show.length/$offset)+1
            end

    redirect_to authentication_files_path

  end


  def files
    $update_form = render_to_string(:partial => "upload_file")
  end

  helper_method :current_user

  def current_user
    $current_user ||= User.find(session[:user_id]) if session[:user_id]
    return $current_user
  end


end

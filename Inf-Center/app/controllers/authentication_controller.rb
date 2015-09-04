require 'rubygems'
require 'mechanize'
# Class that control the Authenticatiom system and its views
class AuthenticationController < ApplicationController


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



  def get_token(email = params[:my_email], senha = params[:my_password]) #It doesn't do nothing at all, for while, just want to keep it here.

  end

end

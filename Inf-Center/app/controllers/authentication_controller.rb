require 'rubygems'
require 'mechanize'

class AuthenticationController < ApplicationController

  def login

  end

  def welcome(email = params[:my_email], senha = params[:my_password])
    @email = email
    url = 'https://auth.aiesec.org/users/sign_in'
    agent = Mechanize.new
    page = agent.get(url)
    aiesec_form = page.form()
    aiesec_form.field_with(:name => 'user[email]').value = email
    aiesec_form.field_with(:name => 'user[password]').value = senha
    page = agent.submit(aiesec_form, aiesec_form.buttons.first)
    cj = agent.cookie_jar

    if page.code.to_s == '200'
      @token = cj.jar['experience.aiesec.org']['/']["aiesec_token"].value
    else
      @token == nil
    end

    if @token == nil
      redirect_to "login"
    end


  end

  def erro

  end



  def get_token(email = params[:my_email], senha = params[:my_password])

  end

end

class DigitalTransformationController < ApplicationController
  # GET /
  def index
    unless params.has_key?('id')
      redirect_to 'http://aiesec.org.br'
      return
    end

    @person = ExpaPerson.find_by_xp_id(params['id'])

    #if @person.nil?
    #  redirect_to 'http://brasil.aiesec.org.br/suporte-durante-o-intercambio'
    #  return
    #end
  end

  # POST /
  def update_person
    redirect_to 'http://brasil.aiesec.org.br/suporte-durante-o-intercambio'
  end
end
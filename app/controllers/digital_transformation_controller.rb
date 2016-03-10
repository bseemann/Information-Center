class DigitalTransformationController < ApplicationController

  # GET /complete_cadastro
  def index
    set_fields
    unless params.has_key?('landing')
      redirect_to 'http://aiesec.org.br'
      return
    end
  end

  # POST /

  def update
    set_fields
    unless (params['controller'] == 'digital_transformation' &&
        params['action'] == 'update') ||
        params['landing'].nil?
      redirect_to 'http://aiesec.org.br'
      return
    end

    person = ExpaPerson.find_by_xp_email(params['form_data']['email'])
    if params['form_data']['programa_interesse'] == '-' ||
        params['form_data']['como_conheceu'] == '-' ||
        params['form_data']['entidade_proxima'] == '-' ||
        params['form_data']['email'].empty? ||
        params['landing'].empty? ||
        !ExpaPerson.exists?(person)
        redirect_to '/complete_cadastro?error=true&landing=' + params['landing'] #TODO: POG
        return

    else
      person.how_got_to_know_aiesec = @how_got_to_know_aiesec.find_index(params['form_data']['como_conheceu']) - 1
      office = ExpaOffice.find_by_xp_name(params['form_data']['entidade_proxima'])
      unless ExpaOffice.exists?(office)
        office = ExpaOffice.new
        office.xp_name = params['form_data']['entidade_proxima']
        office.save
      end
      person.entity_exchange_lc = office
      person.interested_program = 'global_volunteer' if params['form_data']['programa_interesse'].include?'Cidadão Global'
      person.interested_program = 'global_talents' if params['form_data']['programa_interesse'].include?'Talentos Globais'
      person.interested_sub_product = 'global_volunteer_arab' if params['form_data']['programa_interesse'] == 'Cidadão Global Mundo Árabe'
      person.interested_sub_product = 'global_volunteer_east_europe' if params['form_data']['programa_interesse'] == 'Cidadão Global Leste Europeu'
      person.interested_sub_product = 'global_volunteer_africa' if params['form_data']['programa_interesse'] == 'Cidadão Global África'
      person.interested_sub_product = 'global_volunteer_asia' if params['form_data']['programa_interesse'] == 'Cidadão Global Ásia'
      person.interested_sub_product = 'global_volunteer_latam' if params['form_data']['programa_interesse'] == 'Cidadão Global América Latina'
      if person.control_podio.nil?
        person.control_podio = {'podio' => false}.to_json.to_s
      else
        podio = JSON.parse(person.control_podio)
        podio['podio'] = false
        person.control_podio = podio.to_json.to_s
      end
      person.save

      xp_sync = ExpaRdSync.new
      case params['landing']
        when '1' then
          if person.interested_program == 'global_volunteer'
            xp_sync.send_to_rd(person, nil, xp_sync.rd_identifiers[:landing_1], xp_sync.rd_tags[:gcdp])
          elsif person.interested_program == 'global_talents'
            xp_sync.send_to_rd(person, nil, xp_sync.rd_identifiers[:landing_1], xp_sync.rd_tags[:gip])
          end
          redirect_to 'http://brasil.aiesec.org.br/suporte-durante-o-intercambio'
        when '2' then
          if person.interested_program == 'global_volunteer'
            xp_sync.send_to_rd(person, nil, xp_sync.rd_identifiers[:landing_2], xp_sync.rd_tags[:gcdp])
          elsif person.interested_program == 'global_talents'
            xp_sync.send_to_rd(person, nil, xp_sync.rd_identifiers[:landing_2], xp_sync.rd_tags[:gip])
          end
          redirect_to 'https://rdstation-static.s3.amazonaws.com/cms%2Ffiles%2F9299%2F145510483015+dicas+para+viajar+sem+imprevistos.pdf'
        else redirect_to 'http://aiesec.org.br'
      end
    end
  end

  private

  def set_fields
    @interested_program_sub_product = ['-',
                                       'Cidadão Global Mundo Árabe',
                                       'Cidadão Global Leste Europeu',
                                       'Cidadão Global África',
                                       'Cidadão Global Ásia',
                                       'Cidadão Global América Latina']
    @entities = ['-',
                 'ARACAJU',
                 'BALNEARIO CAMBORIU',
                 'BAURU',
                 'BELÉM',
                 'BELO HORIZONTE',
                 'BLUMENAU',
                 'BRASÍLIA',
                 'CAMPINA GRANDE',
                 'CAMPO GRANDE',
                 'CHAPECO',
                 'CUIABA',
                 'CURITIBA',
                 'FLORIANÓPOLIS',
                 'FORTALEZA',
                 'FRANCA',
                 'GOIANIA',
                 'INSPER',
                 'ITAJUBA',
                 'JOAO PESSOA',
                 'JOINVILLE',
                 'LIMEIRA',
                 'LONDRINA',
                 'MACEIO',
                 'MANAUS',
                 'MARILIA',
                 'MARINGÁ',
                 'NATAL',
                 'PASSO FUNDO',
                 'PELOTAS',
                 'POCOS DE CALDAS',
                 'PORTO ALEGRE',
                 'RECIFE',
                 'RIBEIRAO PRETO',
                 'RIO DE JANEIRO',
                 'SALVADOR',
                 'SANTA CRUZ DO SUL',
                 'SANTA MARIA',
                 'SANTAREM',
                 'SANTOS',
                 'SAO CARLOS',
                 'SAO JOSÉ DO RIO PRETO',
                 'SAO PAULO - UNIDADE ABC',
                 'SAO PAULO - UNIDADE ESPM',
                 'SAO PAULO - UNIDADE GV',
                 'SAO PAULO - UNIDADE PUC',
                 'SAO PAULO - UNIDADE USP',
                 'SOROCABA',
                 'TERESINA',
                 'UBERLÂNDIA',
                 'VALE DO PARAÍBA',
                 'VALE DO SAO FRANCISCO',
                 'VICOSA',
                 'VITÓRIA',
                 'VOLTA REDONDA']
    @how_got_to_know_aiesec = ['-',
                               'Facebook',
                               'Indicação de Amigos ou Parentes',
                               'Google',
                               'Cartazes',
                               'TV',
                               'Twitter',
                               'Centro acadêmico',
                               'Empresa Júnior',
                               'Flyer',
                               'Divulgação em sala de aula',
                               'Global Village',
                               'Stand',
                               'Instagram',
                               'Campanha de indicação',
                               'Youth Speak',
                               'Outros']
  end
end
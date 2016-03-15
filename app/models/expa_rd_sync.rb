class ExpaRdSync
  attr_accessor :rd_identifiers
  attr_accessor :rd_tags


  def initialize
    self.rd_identifiers = {
        :test => 'test', #This is the identifier that should always be used during test phase
        :expa => 'expa',
        :open => 'open',
        :landing_1 => 'form-video-suporte-aiesec',
        :landing_2 => '15-dicas-para-planejar-sua-viagem-sem-imprevistos',
        :in_progress => 'in_progress',
        :rejected => 'rejected',
        :accepted => 'accepted',
        :approved => 'approved'
    }

    self.rd_tags = {
        :gip => 'GIP',
        :gcdp => 'GCDP'
    }
  end

  def list_people #TODO testar com mock
    setup_expa_api
    params = {'per_page' => 100}
    total_items = EXPA::Peoples.total_items
    total_pages = total_items / params['per_page']
    total_pages = total_pages + 1 if total_items % params['per_page'] > 0

    for i in 1..total_pages
      params['page'] = i
      people = EXPA::Peoples.list_by_param(params)
      people.each do |xp_person|
        update_db_peoples(xp_person)
      end
    end
  end

  def list_open #TODO testar com mock
    setup_expa_api
    time = Time.now - 10*60 # 10 minutes windows
    people = EXPA::Peoples.list_everyone_created_after(time)
    people.each do |xp_person|
      person = ExpaPerson.find_by_xp_id(xp_person.id)
      if ExpaPerson.exists?(person)
        update_db_peoples(xp_person)
      else
        person = update_db_peoples(xp_person)
        send_to_rd(person, nil, self.rd_identifiers[:open], nil)
      end
    end
  end

  def update_podio
    Podio.setup(:api_key => ENV['PODIO_API_KEY'], :api_secret => ENV['PODIO_API_SECRET'])
    Podio.client.authenticate_with_credentials(ENV['PODIO_USERNAME'], ENV['PODIO_PASSWORD'])

    entities = { 'ARACAJU' => 306817550,
                 'BALNEARIO CAMBORIU' => 306820346,
                 'BAURU' => 306825623,
                 'BELÉM' => 362628356,
                 'BELO HORIZONTE' => 306810804,
                 'BLUMENAU' => 362628487,
                 'BRASILIA' => 306812018,
                 'CAMPINA GRANDE' => 362628658,
                 'CAMPO GRANDE' => 306825376,
                 'CHAPECO' => 306822862,
                 'CUIABA' => 336444212,
                 'CURITIBA' => 306813088,
                 'FLORIANÓPOLIS' => 306811093,
                 'FORTALEZA' => 306810283,
                 'FRANCA' => 306818036,
                 'GOIANIA' => 306817719,
                 'INSPER' => 306817462,
                 'ITAJUBA' => 306822498,
                 'JOAO PESSOA' => 306824849,
                 'JOINVILLE' => 306818877,
                 'LIMEIRA' => 335437867,
                 'LONDRINA' => 3751474,
                 'MACEIO' => 362629308,
                 'MANAUS' => 306817297,
                 'MARILIA' => 362629660,
                 'MARINGÁ' => 306811055,
                 'NATAL' => 362629783,
                 'PASSO FUNDO' => 362630011,
                 'PELOTAS' => 306820564,
                 'POCOS DE CALDAS' => 362630236,
                 'PORTO ALEGRE' => 306810913,
                 'RECIFE' => 306810735,
                 'RIBEIRAO PRETO' => 306820937,
                 'RIO DE JANEIRO' => 306811119,
                 'SALVADOR' => 306811026,
                 'SANTA CRUZ DO SUL' => 306825793,
                 'SANTA MARIA' => 306813159,
                 'SANTAREM' => 353882059,
                 'SANTOS' => 306819356,
                 'SAO CARLOS' => 306812438,
                 'SAO JOSÉ DO RIO PRETO' => 353885407,
                 'ABC' => 340039892,
                 'SAO PAULO - UNIDADE ABC' => 340039892,
                 'ESPM' => 306812929,
                 'SAO PAULO - UNIDADE ESPM' => 306812929,
                 'GV' => 306822659,
                 'SAO PAULO - UNIDADE GV' => 306822659,
                 'PUC' => 306817495,
                 'SAO PAULO - UNIDADE PUC' => 306817495,
                 'USP' => 306817495,
                 'SAO PAULO - UNIDADE USP' => 306817495,
                 'SOROCABA' => 306825137,
                 'TERESINA' => 340037977,
                 'UBERLÂNDIA' => 306813291,
                 'VALE DO PARAÍBA' => 306817098,
                 'VALE DO SAO FRANCISCO' => 362630905,
                 'VICOSA' => 362631010,
                 'VITÓRIA' => 306810868,
                 'VOLTA REDONDA' => 335438552}

    people = ExpaPerson.where.not(control_podio: nil)
    people.each do |person|
      if JSON.parse(person.control_podio).key?('podio') && JSON.parse(person.control_podio)['podio'] == false
        begin
          if person.interested_program == 'global_volunteer'
            podio_app = 14573133
          elsif person.interested_program == 'global_talents'
            podio_app = 14573323
          end

          Podio::Item.create(podio_app, {
              :fields => {
                  'nome' => person.xp_full_name,
                  'email' => [{ 'type' => 'home', 'value' => person.xp_email}],
                  'telefone-2' => [{ 'type' => 'home', 'value' => person.xp_phone }],
                  'nome-da-pessoaentidade-que-lhe-indicou' => 'Robozinho puxou inscrito diretamente do EXPA. Ignore todos os campos menos nome, email e telefone. ID do EXPA: ' + person.xp_id.to_s,
                  'aiesec-mais-proxima2' => entities[person.entity_exchange_lc.xp_name]
              }
          })

        rescue => exception
          puts exception.to_s
        else
          res = JSON.parse(person.control_podio)
          res['podio'] = true
          person.control_podio = res.to_json.to_s
          person.save
        end
      end
    end
  end

  def update_db_peoples(xp_person)
    person = ExpaPerson.find_by_xp_id(xp_person.id)

    if !ExpaPerson.exists?(person)
      person = ExpaPerson.new
    else
      if person.xp_status != xp_person.status.to_s.downcase.gsub(' ','_')
        case xp_person.status.to_s.downcase.gsub(' ','_')
          when 'in_progress' then send_to_rd(xp_person, nil, self.rd_identifiers[:in_progress], nil)
          when 'accepted' then send_to_rd(xp_person, nil, self.rd_identifiers[:accepted], nil)
          when 'approved' then send_to_rd(xp_person, nil, self.rd_identifiers[:approved], nil)
          else nil
        end
      end
    end

    person.update_from_expa(xp_person)
    person.save

    setup_expa_api
    applications = EXPA::Peoples.get_applications(person.xp_id)
    unless applications.empty?
      applications.each do |application|
        update_db_applications(application)
      end
    end
    send_to_rd(person, nil, self.rd_identifiers[:expa], nil) #TODO enviar também applications (somente quanto tá accepted, match, relized, complted)
    person
  end

  def update_db_applications(xp_application)
    application = ExpaApplication.find_by_xp_id(xp_application.id)

    unless ExpaApplication.exists?(application)
      application = ExpaApplication.new
    end

    application.update_from_expa(xp_application)
    application.save
  end

  def send_to_rd(person, application, identifier, tag)
    #TODO: colocar todos os campos do peoples e applications aqui no RD
    #TODO: colocar breaks conferindo todos os campos
    json_to_rd = {}
    json_to_rd['token_rdstation'] = ENV['RD_STATION_TOKEN']
    json_to_rd['identificador'] = identifier
    json_to_rd['email'] = person.xp_email unless person.xp_email.nil?
    json_to_rd['nome'] = person.xp_full_name unless person.xp_full_name.nil?
    json_to_rd['expa_id'] = person.xp_id unless person.xp_id.nil?
    json_to_rd['data_de_nascimento'] = person.xp_birthday_date unless person.xp_birthday_date.nil?
    json_to_rd['entidade'] = person.xp_home_lc.xp_name unless person.xp_home_lc.nil?
    json_to_rd['país'] = person.xp_home_mc.xp_name unless person.xp_home_mc.nil?
    json_to_rd['status'] = person.xp_status unless person.xp_status.nil?
    json_to_rd['entrevistado'] = person.xp_interviewed  unless person.xp_interviewed.nil?
    json_to_rd['telefone'] = person.xp_phone unless person.xp_phone.nil?
    json_to_rd['pagamento'] = person.xp_payment unless person.xp_payment.nil?
    json_to_rd['nps'] = person.xp_nps_score unless person.xp_nps_score.nil?
    json_to_rd['entidade_OGX'] = person.entity_exchange_lc.xp_name unless person.entity_exchange_lc.nil?
    json_to_rd['como_conheceu_AIESEC'] = person.how_got_to_know_aiesec unless person.how_got_to_know_aiesec.nil?
    json_to_rd['programa_interesse'] = person.interested_program unless person.interested_program.nil?
    json_to_rd['sub_produto_interesse'] = person.interested_sub_product unless person.interested_sub_product.nil?
    json_to_rd['tag'] = tag unless tag.nil?
    unless application.nil?
      json_to_rd.merge!{
      }
    end
    uri = URI(ENV['RD_STATION_URL'])
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = json_to_rd.to_json
    begin
      puts https.request(req)
    rescue => exception
      puts exception.to_s
    end
  end

  def setup_expa_api
    if EXPA.client.nil?
      xp = EXPA.setup()
      xp.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    end
  end
end
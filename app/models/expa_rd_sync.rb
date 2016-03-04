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
      person = update_db_peoples(xp_person)
      send_to_rd(person, nil, self.rd_identifiers[:open], nil)
    end
  end

  def update_db_peoples(xp_person)
    person = ExpaPerson.find_by_xp_id(xp_person.id)

    if !ExpaPerson.exists?(person)
      person = ExpaPerson.new
    else
      if person.xp_status != xp_person.status
        case xp_person.status
          when 'in progress' then send_to_rd(xp_person, nil, self.rd_identifiers[:in_progress], nil)
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
    if applications.nil?
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
    uri = URI(ENV['RD_STATION_TOKEN'])
    https = Net::HTTP.new(uri.host,uri.port)
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
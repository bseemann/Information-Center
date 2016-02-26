class ExpaRdSync
  def initialize
    @rd_identifiers = {
        :test => 'test', #This is the identifier that should always be used during test phase
        :expa => 'expa',
        :open => 'open',
        :enable => 'enable',
        :in_progress => 'in_progress',
        :accepted => 'accepted',
        :approved => 'approved'
    }

    @rd_tags = {

    }
  end

  def list_people #TODO testar com mock
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
    time = Time.now - 10*60 # 10 minutes windows
    people = EXPA::Peoples.list_everyone_created_after(time)
    people.each do |person|
      send_to_rd(person, nil, @rd_identifiers[:open], nil)
    end
  end

  def update_db_peoples(xp_person)
    person = ExpaPerson.find_by_xp_id(xp_person.id)

    if person.nil?
      person = ExpaPerson.new
    else
      if person.xp_status != xp_person.status
        case xp_person.status
          when 'in progress' then send_to_rd(xp_person, nil, @rd_identifiers[:in_progress], nil)
          when 'accepted' then send_to_rd(xp_person, nil, @rd_identifiers[:accepted], nil)
          when 'approved' then send_to_rd(xp_person, nil, @rd_identifiers[:approved], nil)
          else nil
        end
      end
    end

    person.update_from_expa(xp_person)
    person.save

    setup_expa_api
    applications = EXPA::Peoples.get_applications(person.xp_id)
    unless applications.nil?
      applications.each do |application|
        update_db_applications(application)
      end
    end
    send_to_rd(person, nil, @rd_identifiers[:test], nil) #TODO enviar também applications (somente quanto tá accepted, match, relized, complted)
  end

  def update_db_applications(xp_application)
    application = ExpaApplication.find_by_xp_id(xp_application.id)

    if application.nil?
      application = ExpaApplication.new
    end

    application.update_from_expa(xp_application)
    application.save
  end

  def send_to_rd(person, application, identifier, tag)
    #TODO: colocar todos os campos do peoples e applications aqui no RD
    json_to_rd = {
        'token_rdstation' => ENV['RD_STATION_TOKEN'],
        'identificador' => identifier,
        'email' => person.xp_email,
        'nome' => person.xp_full_name.to_s + person.xp_last_name,
        'telefone' => person.xp_phone,
        'expa_id' => person.xp_id,
        'expa_url' => person.xp_url,
    }
    json_to_rd['tag'] = tag unless tag.nil?
    unless application.nil?
      json_to_rd.merge!{

      }
    end
    uri = URI(ENV['RD_STATION_TOKEN'])
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = json_to_rd.to_json
    begin
      https.request(req)
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
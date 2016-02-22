class ExpaRdSync
  @rd_identifiers = {
      :test => 'test',
      :new_lead => '',
      :update_lead => '',
      :in_progress => '',
      :match => '',
      :realize => '',
      :rejected => '',
      :completed => ''
  }

  @rd_tags = {

  }
  def initialize

  end

  def list_people
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

  def update_db_peoples(xp_person)
    person = ExpaPerson.new do |p|
      p.xp_id = xp_person.id
      p.xp_email = xp_person.email
      p.xp_url = xp_person.url.to_s
      #p.xp_birthday_date = xp_person.birthday_date
      p.xp_full_name = xp_person.full_name
      p.xp_last_name = xp_person.last_name
      p.xp_profile_photo_url = xp_person.profile_photo_url.to_s
      p.xp_status = xp_person.status
      p.xp_phone = xp_person.phone
      p.xp_created_at = xp_person.created_at
      p.xp_updated_at = xp_person.updated_at
      p.xp_middles_names = xp_person.middles_names
      p.xp_aiesec_email = xp_person.aiesec_email
      p.xp_contacted_at = xp_person.contacted_at
      p.xp_contacted_by = xp_person.contacted_by
      p.xp_gender = xp_person.gender
      p.xp_address_info = xp_person.address_info
      p.xp_contact_info = xp_person.contact_info
    end
    person.save
    setup_expa_api
    applications = EXPA::Peoples.get_applications(person.xp_id)
    unless applications.nil?
      applications.each do |application|
        update_db_applications(application)
      end
    end

  end

  def update_db_applications(xp_application)
    application = ExpaApplication.new do |a|
      a.xp_id = xp_application.id
      a.xp_url =xp_application.url
      #a.xp_matchability =xp_application.matchability
      a.xp_status =xp_application.status
      a.xp_current_status =xp_application.current_status
      #a.xp_id =xp_application.favourite
      #a.xp_id =xp_application.permissions
      a.xp_created_at =xp_application.created_at
      a.xp_updated_at =xp_application.updated_at
      #a.xp_id =xp_application.opportunity
    end
    application.save
  end

  def update_db_offices

  end

  def sync_rd_station

  end

  def send_to_rd(person, applications, identifier, tag)
    json_to_rd = {
        'token_rdstation' => ENV['RD_STATION_TOKEN'],
        'identificador' => identifier,
        'email' => person.xp_email,
        'nome' => person.xp_full_name.to_s + person.xp_last_name,
        'cargo' => '',
        'empresa' => '',
        'telefone' => person.xp_phone,
        'expa_id' => person.xp_id,
        'expa_url' => person.xp_url,
    }
    json_to_rd['tag'] = tag unless tag.nil?
    unless applications.empty?
      json_to_rd.merge!{

      }
    end
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
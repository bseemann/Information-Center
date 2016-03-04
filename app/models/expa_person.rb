class ExpaPerson < ActiveRecord::Base
  enum status: [:open, :in_progress, :accepted, :approved, :realized, :completed]
  enum gender: [:male, :female]
  enum interested_program: [:global_volunteer, :global_talents]
  enum interested_sub_product: [:global_volunteer_arab, :global_volunteer_east_europe, :global_volunteer_africa, :global_volunteer_asia, :global_volunteer_latam]
  enum how_got_to_know_aiesec: [:facebook, :friends_family, :google, :posters, :tv, :twitter, :academic_center, :junior_company, :flyer, :disclouse_in_classroom, :global_village, :stand, :instagram, :indication_campaign, :youth_speak, :other]

  #attr_accessor :applications

  belongs_to :xp_home_lc, class_name: 'ExpaOffice'
  belongs_to :xp_home_mc, class_name: 'ExpaOffice'
  belongs_to :xp_current_office, class_name: 'ExpaOffice'
  belongs_to :entity_exchange_lc, class_name: 'ExpaOffice'

  validates :xp_id,
            uniqueness: true
  validates :xp_email,
            uniqueness: true

  after_validation :downcase_email

  def update_from_expa(data)
    unless data.home_lc.nil?
      home_lc = ExpaOffice.new
      home_lc.update_from_expa(data.home_lc)
      home_lc.save
    end
    unless data.home_mc.nil?
      home_mc = ExpaOffice.new
      home_mc.update_from_expa(data.home_mc)
      home_mc.save
    end
    unless data.current_office.nil?
      current_office = ExpaOffice.new
      current_office.update_from_expa(data.current_office)
      current_office.save
    end


    self.xp_id = data.id unless data.id.nil?
    self.xp_email = data.email unless data.email.nil?
    self.xp_url = data.url.to_s unless data.url.nil?
    self.xp_birthday_date = data.birthday_date unless data.birthday_date.nil?
    self.xp_full_name = data.full_name unless data.full_name.nil?
    self.xp_last_name = data.last_name unless data.last_name.nil?
    self.xp_profile_photo_url = data.profile_photo_url.to_s unless data.profile_photo_url.nil?
    self.xp_home_lc = home_lc unless home_lc.nil?
    self.xp_home_mc = home_mc unless home_mc.nil?
    self.xp_status = data.status unless data.status.nil?
    self.xp_interviewed = data.interviewed unless data.interviewed.nil?
    self.xp_phone = data.phone unless data.phone.nil?
    self.xp_location = data.location unless data.location.nil?
    self.xp_created_at = data.created_at unless data.created_at.nil?
    self.xp_updated_at = data.updated_at unless data.updated_at.nil?
    self.xp_middles_names = data.middles_names unless data.middles_names.nil?
    self.xp_introduction = data.introduction unless data.introduction.nil?
    self.xp_aiesec_email = data.aiesec_email unless data.aiesec_email.nil?
    self.xp_payment = data.payment unless data.payment.nil?
    #self.xp_programmes = data.programmes #TODO: struct
    self.xp_views = data.views unless data.views.nil?
    self.xp_favourites_count = data.favourites_count.to_i unless data.favourites_count.nil?
    self.xp_contacted_at = data.contacted_at unless data.contacted_at.nil?
    self.xp_contacted_by = data.contacted_by unless data.contacted_by.nil?
    self.xp_gender = data.gender unless data.gender.nil?
    self.xp_address_info = data.address_info unless data.address_info.nil?
    self.xp_contact_info = data.contact_info unless data.contact_info.nil?
    self.xp_current_office = current_office unless current_office.nil?
    self.xp_cv_info = data.cv_info unless data.cv_info.nil?
    self.xp_profile_photos_urls = data.profile_photos_urls unless data.profile_photos_urls.nil?
    self.xp_cover_photo_urls = data.cover_photo_urls unless data.cover_photo_urls.nil?
    #self.xp_teams = data.teams #TODO: struct
    #self.xp_positions = data.positions #TODO: struct
    self.xp_profile = data.profile unless data.profile.nil?
    #self.xp_academic_experience = data.academic_experience #TODO: struct
    #self.xp_professional_experience = data.professional_experience #TODO: struct
    #self.xp_managers = data.managers #TODO: struct
    self.xp_missing_profile_fields = data.missing_profile_fields unless data.missing_profile_fields.nil?
    self.xp_nps_score = data.nps_score.to_i unless data.nps_score.nil?
    #self.xp_current_experience = data.current_experience #TODO: struct
    self.xp_permissions = data.permissions unless data.permissions.nil?
  end

  def applications
    if applications.nil?
      xp = EXPA.setup()
      #TODO: EXPA.setup.auth(logged_email, logged_password)
      xp.auth(ENV['ROBOZINHO_EMAIL'], ENV['ROBOZINHO_PASSWORD'])
      self.applications = EXPA::Peoples.list_applications_by_id(self.xp_id)
    else
      self.applications
    end
  end

  def complete_full_name
    self.xp_full_name + self.xp_middles_names + self.xp_last_name
  end

  private

  def downcase_email
    self.xp_email.downcase unless self.xp_email.nil?
    self.xp_aiesec_email.downcase unless self.xp_aiesec_email.nil?
  end

  def xp_status_to_s
    #TODO method
  end

  def xp_status_from_s(s)
    #TODO method
  end

end

class ExpaPerson < ActiveRecord::Base
  #attr_accessor :applications

  has_one :xp_home_lc, class_name: 'ExpaOfficezxc'
  has_one :xp_home_mc, class_name: 'ExpaOfficezxc'
  #has_one :xp_contacted_by

  validates :xp_id,
            uniqueness: true
  validates :xp_email,
            uniqueness: true
  validates :xp_aiesec_email,
            uniqueness: true

  after_validation :downcase_email

  @enum_gender = {:male => 'Male',
                  :female => 'Female'}

  def applications
    if applications.nil?
      xp = EXPA.setup()
      #TODO: EXPA.setup.auth(logged_email, logged_password)
      xp.auth(ENV['ROBOZINHO_EMAIL'], ENV['ROBOZINHO_PASSWORD'])
      self.applications = EXPA::Peoples.list_applications_by_id()
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

  def xp_gender_to_s
    @enum_gender[:male] if self.male?
    @enum_gender[:female] if self.female?
  end

  def xp_gender_from_s(s)
    case s
      when @enum_gender[:male] then self.male!
      when @enum_gender[:female] then self.female!
    end
  end

  def male!
    self.xp_gender = 1
  end

  def female!
    self.xp_gender = 2
  end

  def male?
    self.xp_gender == 1
  end

  def female?
    self.xp_gender == 2
  end
end

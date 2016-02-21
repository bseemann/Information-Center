class Person < ActiveRecord::Base
  attr_accessor :applications

  has_one :expa_home_lc, class_name: 'Office'
  has_one :expa_home_mc, class_name: 'Office'
  has_one :expa_contacted_by

  validates :expa_id,
            uniqueness: true
  validates :expa_email,
            uniqueness: true
  validates :expa_aiesec_mail,
            uniqueness: true

  after_validation :downcase_email

  @enum_gender = {:male => 'Male',
                  :female => 'Female'}

  def applications
    if applications.nil?
      #TODO: EXPA.setup.auth(logged_email, logged_password)
      EXPA.setup.auth(ENV['ROBOZINHO_EMAIL'], ENV['ROBOZINHO_PASSWORD'])
      self.applications = EXPA::Peoples.list_applications_by_id()
    else
      self.applications
    end
  end

  def complete_full_name
    self.expa_full_name + self.expa_middles_names + self.expa_last_name
  end

  private

  def downcase_email
    self.expa_mail.downcase unless self.expa_mail.nil?
    self.expa_aiesec_mai.downcase unless self.expa_aiesec.mail.nil?
  end

  def expa_status_to_s
    #TODO method
  end

  def expa_status_from_s(s)
    #TODO method
  end

  def expa_gender_to_s
    @enum_gender[:male] if self.male?
    @enum_gender[:female] if self.female?
  end

  def expa_gender_from_s(s)
    case s
      when @enum_gender[:male] then self.male!
      when @enum_gender[:female] then self.female!
    end
  end

  def male!
    self.expa_gender = 1
  end

  def female!
    self.expa_gender = 2
  end

  def male?
    self.expa_gender == 1
  end

  def female?
    self.expa_gender == 2
  end
end

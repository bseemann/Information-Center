class ExpaOffice < ActiveRecord::Base
  belongs_to :expa_person

  validates :xp_id,
            uniqueness: true
  validates :xp_url,
            uniqueness: true
end

class Office < ActiveRecord::Base
  belongs_to :person

  validates :expa_id,
            uniqueness: true
  validates :expa_url,
            uniqueness: true

end

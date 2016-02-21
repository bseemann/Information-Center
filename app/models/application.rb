class Application < ActiveRecord::Base
  validates :expa_id,
            uniqueness: true
  validates :expa_url,
            uniqueness: true
end

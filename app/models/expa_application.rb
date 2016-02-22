class ExpaApplication < ActiveRecord::Base
  validates :xp_id,
            uniqueness: true
  validates :xp_url,
            uniqueness: true
end

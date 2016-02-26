class ExpaApplication < ActiveRecord::Base
  enum xp_current_status: [:current_open, :current_in_progress, :current_accepted, :current_matched, :current_realized] #TODO: Use prefix when they launch outside edge
  enum xp_status: [:open, :in_progress, :accepted, :matched, :realized] #TODO: Use prefix when they launch outside edge

  validates :xp_id,
            uniqueness: true

  def update_from_expa(data)
    self.xp_id = data.id
    self.xp_url = data.url
    #self.xp_matchability = data.matchability
    self.xp_status = data.status.to_s.downcase.gsub(' ','_')
    self.xp_current_status = 'current_' + data.current_status.to_s.downcase.gsub(' ','_') #TODO: Use prefix when they launch outside edge
    #self.xp_favourite = data.favourite
    #self.xp_permissions = data.permissions
    self.xp_created_at = data.created_at
    self.xp_updated_at = data.updated_at
    #self.xp_opportunity = data.opportunity
  end
end

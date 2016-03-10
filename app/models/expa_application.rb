class ExpaApplication < ActiveRecord::Base
  enum xp_current_status: [:current_open, :current_in_progress, :current_accepted, :current_matched, :current_realized] #TODO: Use prefix when they launch outside edge
  enum xp_status: [:open, :in_progress, :accepted, :matched, :realized] #TODO: Use prefix when they launch outside edge

  validates :xp_id,
            uniqueness: true,
            presence: false

  def update_from_expa(data)
    self.xp_id = data.id unless data.id.nil?
    self.xp_url = data.url unless data.url.nil?
    #self.xp_matchability = data.matchability unless data.matchability.nil?
    self.xp_status = data.status.to_s.downcase.gsub(' ','_') unless data.status.nil?
    self.xp_current_status = 'current_' + data.current_status.to_s.downcase.gsub(' ','_') unless data.current_status.nil? #TODO: Use prefix when they launch outside edge
    #self.xp_favourite = data.favourite unless data.favourite.nil?
    #self.xp_permissions = data.permissions unless data.data.permissions.nil?
    self.xp_created_at = data.created_at unless data.created_at.nil?
    self.xp_updated_at = data.updated_at unless data.updated_at.nil?
    #self.xp_opportunity = data.opportunity unless data.opportunity.nil?
  end
end

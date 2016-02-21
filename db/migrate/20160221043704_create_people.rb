class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :expa_id
      t.string :expa_email
      t.string :expa_url
      t.string :expa_full_name
      t.string :expa_last_name
      t.string :expa_profile_photo_url
      t.integer :expa_home_lc #foreigner_key
      t.integer :expa_home_mc #foreigner_key
      t.integer :expa_status #enum
      #t.string :expa_interviewed
      t.string :expa_phone
      #t.string :expa_location
      t.timestamp :expa_created_at
      t.timestamp :expa_updated_at
      t.string :expa_middles_names
      #t.string :expa_introduction
      t.string :expa_aiesec_email
      #t.string :expa_payment
      #t.string :expa_programmes
      #t.string :expa_views
      #t.string :expa_favourites_count
      t.timestamp :expa_contacted_at
      t.integer :expa_contacted_by #foreiger_key
      t.integer :expa_gender #enum
      t.text :expa_address_info
      t.string :expa_contact_info
      #t.string :expa_current_office
      #t.string :expa_cv_info
      #t.string :expa_profile_photos_urls
      #t.string :expa_cover_photo_urls
      #t.string :expa_teams
      #t.string :expa_positions
      #t.string :expa_profile
      #t.string :expa_academic_experience
      #t.string :expa_professional_experience
      #t.string :expa_managers
      #t.string :expa_missing_profile_fields
      #t.string :expa_nps_score
      #t.string :expa_current_experience
      #t.string :expa_permissions


      t.timestamps null: false
    end
  end
end

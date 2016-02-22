class CreateExpaPeople < ActiveRecord::Migration
  def change
    create_table :expa_people do |t|
      t.integer :xp_id
      t.string :xp_email
      t.string :xp_url
      #t.date :xp_birthday_date
      t.string :xp_full_name
      t.string :xp_last_name
      t.string :xp_profile_photo_url
      t.integer :xp_home_lc #foreigner_key (Office)
      t.integer :xp_home_mc #foreigner_key (Office)
      t.integer :xp_status #Enum (From String to Enum)
      #t.string :xp_interviewed
      t.string :xp_phone
      #t.string :xp_location
      t.timestamp :xp_created_at
      t.timestamp :xp_updated_at
      t.string :xp_middles_names
      #t.string :xp_introduction
      t.string :xp_aiesec_email
      #t.string :xp_payment
      #t.string :xp_programmes
      #t.string :xp_views
      #t.string :xp_favourites_count
      t.timestamp :xp_contacted_at
      t.integer :xp_contacted_by #foreiger_key (Person)
      t.integer :xp_gender #enum (From String to Enum)
      t.text :xp_address_info
      t.string :xp_contact_info
      #t.string :xp_current_office
      #t.string :xp_cv_info
      #t.string :xp_profile_photos_urls
      #t.string :xp_cover_photo_urls
      #t.string :xp_teams
      #t.string :xp_positions
      #t.string :xp_profile
      #t.string :xp_academic_experience
      #t.string :xp_professional_experience
      #t.string :xp_managers
      #t.string :xp_missing_profile_fields
      #t.string :xp_nps_score
      #t.string :xp_current_experience
      #t.string :xp_permissions

      t.timestamps null: false
    end
  end
end

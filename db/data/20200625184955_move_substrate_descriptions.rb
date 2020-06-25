class MoveSubstrateDescriptions < ActiveRecord::Migration[5.2]
  def up

    astek_website = Website.find_by(domain: 'astek.com')
    astek_home_website = Website.find_by(domain: 'astekhome.com')

    Substrate.all.each do |s|
      s.descriptions.delete_all

      if s.description.present?
        s.descriptions.create!(description: s.description, websites: [astek_website])
      end

      if s.display_description.present?
        s.descriptions.create!(description: s.display_description, websites: [astek_home_website])
      end
    end

    # raise
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end

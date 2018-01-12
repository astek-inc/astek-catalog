class PopulateWebsites < ActiveRecord::Migration

  WEBSITES = [
      { name: 'Astek Wallcovering', domain: 'astekwallcovering.com' },
      { name: 'Design Your Wall', domain: 'designyourwall.com' },
      { name: 'OnAir Design', domain: 'onairdesignla.com' },
  ]

  def self.up
    WEBSITES.each do |w|
      Website.create!(w)
    end
  end

  def self.down
    WEBSITES.each do |w|
      Website.find_by(domain: w[:domain]).destroy!
    end
    # raise ActiveRecord::IrreversibleMigration
  end

end

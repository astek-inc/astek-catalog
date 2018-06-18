class PopulateWebsites < ActiveRecord::Migration

  WEBSITES = [
      { name: 'Astek Wallcovering', domain: 'astek.com' },
      { name: 'Design Your Wall', domain: 'astekhome.com' },
      { name: 'OnAir Design', domain: 'onairdesign.com' },
  ]

  def self.up
    WEBSITES.each do |w|
      website = Website.new(w)
      website.save!(w)
    end
  end

  def self.down
    WEBSITES.each do |w|
      Website.find_by(domain: w[:domain]).destroy!
    end
  end

end

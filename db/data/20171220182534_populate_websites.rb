class PopulateWebsites < ActiveRecord::Migration

  WEBSITES = [
      { name: 'Astek Business', domain: 'astek.com' },
      { name: 'Astek Home', domain: 'astekhome.com' },
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

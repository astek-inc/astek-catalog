class PopulateSites < ActiveRecord::Migration

  SITES = [
      { name: 'Astek Wallcovering', domain: 'astekwallcovering.com' },
      { name: 'Design Your Wall', domain: 'designyourwall.com' },
      { name: 'OnAir Design', domain: 'onairdesignla.com' },
  ]

  def self.up
    SITES.each do |w|
      site = Site.new(w)
      site.save!(w)
    end
  end

  def self.down
    SITES.each do |w|
      Site.find_by(domain: w[:domain]).destroy!
    end
  end

end

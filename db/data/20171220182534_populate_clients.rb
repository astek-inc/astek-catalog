class PopulateClients < ActiveRecord::Migration

  CLIENTS = [
      { name: 'Astek Wallcovering', domain: 'astekwallcovering.com' },
      { name: 'Design Your Wall', domain: 'designyourwall.com' },
      { name: 'OnAir Design', domain: 'onairdesignla.com' },
  ]

  def self.up
    CLIENTS.each do |w|
      site = Client.new(w)
      site.token = Client.generate_token
      site.save!(w)
    end
  end

  def self.down
    CLIENTS.each do |w|
      Client.find_by(domain: w[:domain]).destroy!
    end
  end

end

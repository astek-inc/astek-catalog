class PopulateStyles < ActiveRecord::Migration

  STYLES = [
    'Abstract',
    'Animalia',
    'Art Deco',
    'Art Nouveau',
    'Botanical',
    'Children\'s',
    'Contemporary',
    'Damask',
    'Faux Finish',
    'Geometric',
    'Illustrative',
    'Painterly',
    'Photographic',
    'Retro + Vintage',
    'Scenic + Toile',
    'Stripes + Plaid',
    'Textural',
    'Traditional',
    'Tropical',
    'Whimsical'
  ]

  def up
    STYLES.each do |s|
      Style.create!(name: s)
    end
  end

  def down
    Styles.destroy!
  end
end

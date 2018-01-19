class PopulateStyles < ActiveRecord::Migration

  STYLES = [
    'Abstract',
    'Animal Print',
    'Architectural',
    'Art Deco / Art Nouveau',
    'Childrens',
    'Contemporary',
    'Damask',
    'Faux Finish',
    'Floral',
    'Geometric',
    'Illustrative',
    'Large Scale',
    'Nature',
    'Painterly',
    'Photographic',
    'Retro / Vintage',
    'Scenic / Toile',
    'Stripes / Plaid',
    'Textile (TBD)',
    'Textural',
    'Traditional',
    'Tropical',
    'Whimsical',
    'Vintage'
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

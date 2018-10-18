class PopulateColors < ActiveRecord::Migration

  DATA = [
      {name: 'Black and White'},
      {name: 'Beige'},
      {name: 'Black'},
      {name: 'Blue'},
      {name: 'Bronze'},
      {name: 'Brown'},
      {name: 'Cream'},
      {name: 'Gold'},
      {name: 'Green'},
      {name: 'Grey'},
      {name: 'Neutral'},
      {name: 'Off-White'},
      {name: 'Orange'},
      {name: 'Pink'},
      {name: 'Purple'},
      {name: 'Red'},
      {name: 'Silver'},
      { name: 'Translucent' },
      {name: 'White'},
      {name: 'Yellow'},
      {name: 'Multi'}
  ]

  def up
    DATA.each do |i|
      Color.create!(i)
    end
  end

  def down
    Color.destroy_all
  end

end

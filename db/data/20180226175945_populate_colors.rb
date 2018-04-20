class PopulateColors < ActiveRecord::Migration

  DATA = [
    {name: 'Red'},
    {name: 'Orange'},
    {name: 'Yellow'},
    {name: 'Green'},
    {name: 'Blue'},
    {name: 'Indigo'},
    {name: 'Violet'},
    {name: 'Brown'},
    {name: 'Black and White'},
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

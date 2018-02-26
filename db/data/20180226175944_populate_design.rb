class PopulateDesign < ActiveRecord::Migration
  def up
    Design.create!({
         collection: Collection.find_by(name: 'Micrographia'),
         name: 'Lumen',
         description: 'Our printers use a digital process which is eco-friendly, allows for a wide range of printing effects, low print minimums, fast turnarounds and detailed control over output and quality.',
         keywords: 'super, awesome, amazing, fantastic, incredible',
         available_on: Time.now
     })
  end

  def down
    Design.find_by(name: 'Lumen').destroy!
  end
end

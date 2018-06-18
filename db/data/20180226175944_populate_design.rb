class PopulateDesign < ActiveRecord::Migration
  def up
    collection = Collection.find_by(name: 'Micrographia')
    Design.create!({
         collection: collection,
         name: 'Lumen',
         description: 'Our printers use a digital process which is eco-friendly, allows for a wide range of printing effects, low print minimums, fast turnarounds and detailed control over output and quality.',
         keywords: 'super, awesome, amazing, fantastic, incredible',
         available_on: Time.now
     })
    Design.create!({
         collection: collection,
         name: 'Apparition',
         description: 'The ghostliness is tremendously eerie. Few can view this design without being scared out of their wits. Paste this on your walls if you dare.',
         keywords: 'unbelievable, awesome, stupendous, fantastic',
         available_on: Time.now
    })
    # Design.create!({
    #    collection: Collection.find_by(name: 'Micrographia'),
    #    name: 'Apparition',
    #    description: 'Our printers use a digital process which is eco-friendly, allows for a wide range of printing effects, low print minimums, fast turnarounds and detailed control over output and quality.',
    #    keywords: 'super, awesome, amazing, fantastic, incredible',
    #    available_on: Time.now
    # })
  end

  def down
    Design.find_by(name: 'Lumen').destroy!
    Design.find_by(name: 'Apparition').destroy!
  end
end

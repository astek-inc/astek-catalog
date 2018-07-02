class PopulateDesign < ActiveRecord::Migration

  def up

    collection = Collection.find_by(name: 'Micrographia')
    sale_unit = SaleUnit.find_by(name: 'Set')

    Design.create!({
      collection: collection,
      name: 'Lumen',
      description: 'Some say the brilliance of this design is overwheming. Only the true elite can cope with its quality. Are you among them?',
      keywords: 'super, awesome, amazing, fantastic, incredible',
      available_on: Time.now,
      sale_unit: sale_unit,
      price: 179.99
    })

    Design.create!({
      collection: collection,
      name: 'Apparition',
      description: 'The ghostliness is tremendously eerie. Few can view this design without being scared out of their wits. Paste this on your walls if you dare.',
      keywords: 'unbelievable, awesome, stupendous, fantastic',
      available_on: Time.now,
      sale_unit: sale_unit,
      price: 179.99
    })

    Design.create!({
       collection: Collection.find_by(name: 'Micrographia'),
       name: 'Xylem',
       description: 'Simply put, this is the single greatest design in the history of the world. No wall is worthy of it. Please select somethign else.',
       keywords: 'intense, terrific, astounding, wonderful',
       available_on: Time.now,
       sale_unit: sale_unit,
       price: 179.99
    })

  end

  def down
    Design.find_by(name: 'Lumen').destroy!
    Design.find_by(name: 'Apparition').destroy!
    Design.find_by(name: 'Xylem').destroy!
  end
end

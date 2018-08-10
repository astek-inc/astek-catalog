class PopulateDesign < ActiveRecord::Migration

  def up

    product_type = ProductType.find_by(name: 'Studio')
    collection = Collection.find_by(name: 'Micrographia')
    sale_unit = SaleUnit.find_by(name: 'Set')

    design = Design.create!({
      collection: collection,
      name: 'Lumen',
      description: 'Some say the brilliance of this design is overwheming. Only the true elite can cope with its quality. Are you among them?',
      keywords: 'super, awesome, amazing, fantastic, incredible',
      available_on: Time.now,
      product_type: product_type,
      sale_unit: sale_unit,
      price: 179.99,
      styles: Style.where(name: ['Abstract', 'Contemporary'])
    })
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'mural_width'), value: '148.96')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'mural_height'), value: '96')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'repeat_match_type'), value: 'Straight reversible')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'fire_rating'), value: 'Class A')

    design = Design.create!({
      collection: collection,
      name: 'Apparition',
      description: 'The ghostliness is tremendously eerie. Few can view this design without being scared out of their wits. Paste this on your walls if you dare.',
      keywords: 'unbelievable, awesome, stupendous, fantastic',
      available_on: Time.now,
      product_type: product_type,
      sale_unit: sale_unit,
      price: 179.99,
      styles: Style.where(name: ['Abstract', 'Contemporary'])
    })
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'mural_width'), value: '200')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'mural_height'), value: '70')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'repeat_match_type'), value: 'Straight reversible')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'fire_rating'), value: 'Class A')

    design = Design.create!({
       collection: Collection.find_by(name: 'Micrographia'),
       name: 'Xylem',
       description: 'Simply put, this is the single greatest design in the history of the world. No wall is worthy of it. Please select something else.',
       keywords: 'intense, terrific, astounding, wonderful',
       available_on: Time.now,
       product_type: product_type,
       sale_unit: sale_unit,
       price: 179.99,
       styles: Style.where(name: ['Abstract', 'Contemporary', 'Geometric'])
    })
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'mural_width'), value: '170.44')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'mural_height'), value: '108')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'repeat_match_type'), value: 'Straight reversible')
    design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: 'fire_rating'), value: 'Class A')

  end

  def down
    Design.find_by(name: 'Lumen').destroy!
    Design.find_by(name: 'Apparition').destroy!
    Design.find_by(name: 'Xylem').destroy!
  end
end

class PopulateVariantTypes < ActiveRecord::Migration

  VARIANT_TYPES = [
      { name: 'Color Way' },
      { name: 'Master' },
  ]

  def up
    VARIANT_TYPES.each do |type|
      VariantType.create!(type)
    end
  end

  def down
    VARIANT_TYPES.each do |type|
      VariantType.find_by(name: type[:name]).destroy!
    end
  end
end

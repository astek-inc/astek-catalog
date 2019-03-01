class SetDigitalsCountryOfOrigin < ActiveRecord::Migration
  def up
     sql = "UPDATE
        designs
      SET
        country_id = (SELECT id FROM countries WHERE name = 'United States')
      WHERE
        collection_id IN(
          SELECT id FROM collections WHERE product_category_id = (SELECT id FROM product_categories WHERE name = 'Digital')
        )"
    ActiveRecord::Base.connection.exec_query(sql)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

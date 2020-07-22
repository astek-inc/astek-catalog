class UpdatePackageDimsForDigitalVariantsOnPaper < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.connection.execute(
        "SELECT
          V.id AS variant_id,
          V.name AS variant_name,
          V.depth,
          S.name AS substrate_name,
          D.name AS design_name,
          C.name AS collection_name
        FROM
          variants V
          INNER JOIN substrates S ON V.substrate_id = S.id
          INNER JOIN designs D ON V.design_id = D.id
          INNER JOIN collections C ON D.collection_id = C.id
          INNER JOIN product_categories PC ON C.product_category_id = PC.id
      WHERE
          S.name = 'Paper'
          AND PC.name = 'Digital'
          AND V.depth != 61.0"
    ).each_with_index do |r, i |
      Variant.find(r['variant_id']).update_attribute('depth', BigDecimal(61, 2))
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

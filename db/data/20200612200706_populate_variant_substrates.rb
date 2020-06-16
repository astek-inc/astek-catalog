class PopulateVariantSubstrates < ActiveRecord::Migration[5.2]
  def up
    require 'pp'
    arr = []
    Collection.where(product_category_id: 1).each do |c|
      # arr << "Collection: #{c.name}"

      c.designs.each do |d|
        # arr << "Design: #{d.name}"

        d.variants.each do |v|
          # arr << "Variant: #{v.name}"
          # arr << "Substrate: #{v.substrate.name}"
          # pp v

          unless v.substrate_id.nil?
            puts "Collection: #{c.name}"
            puts "Design: #{d.name}"
            puts "Variant: #{v.name}"
            puts "Substrate: #{v.substrate.name}"
            puts '---'


            VariantSubstrate.create! variant: v, substrate: v.substrate, websites: v.websites

            # break

          end

        end

      end

    end

    # puts arr


    # raise
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end

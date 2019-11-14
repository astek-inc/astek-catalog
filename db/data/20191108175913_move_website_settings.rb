class MoveWebsiteSettings < ActiveRecord::Migration[5.2]
  def up
    Collection.all.each do |c|

      binds = [ ActiveRecord::Relation::QueryAttribute.new(
          "collection_id", c.id, ActiveRecord::Type::Integer.new
      )]

      result = ApplicationRecord.connection.exec_query(
          'SELECT website_id FROM collections_websites WHERE collection_id = $1', 'sql', binds
      )
      website_ids = result.to_a.map { |r| r['website_id'] }
      websites = Website.where(id: website_ids)

      c.websites = websites

      c.designs.each do |d|
        d.websites = websites

        d.variants.each do |v|
          v.websites = websites

          v.variant_install_images.each do |i|
            i.websites = websites
          end
        end
      end

    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

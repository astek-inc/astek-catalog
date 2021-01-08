require "#{Rails.root}/lib/admin/tearsheet_generator.rb"

module Admin
  module ImportProductFromCsvItem

    MILLS_NOT_REQUIRING_PRICE_OR_SHIPPING_INFO = ['Brewster', 'Thibaut', 'Wallquest']

    KEYWORD_REPLACEMENTS = [
        ['20s', '1920s'],
        ['3-d', '3d'],
        ['30s', '1930s'],
        ['40s', '1940s'],
        ['50s', '1950s'],
        ['60s', '1960s'],
        ['70s', '1970s'],
        ['airplanes', 'airplane'],
        ['Alpes', 'mountain'],
        ['anchors', 'anchor'],
        ['Andes', 'mountain'],
        ['angels', 'angel'],
        ['animals', 'animal'],
        ['antique texture', 'antique'],
        ['arrows', 'arrow'],
        ['automotive', 'automobile'],
        ['berries', 'berry'],
        ['bird cage', 'birdcage'],
        ['birds', 'bird'],
        ['birds in trees', 'bird'],
        ['blossoms', 'blossom'],
        ['botanica', 'botanical'],
        ['botanicla', 'botanical'],
        ['bows', 'bow'],
        ['boxes', 'box'],
        ['branches', 'branch'],
        ['brick wall', 'brick'],
        ['Bricks', 'brick'],
        ['brush strokes', 'brushstrokes'],
        ['brush-stroke', 'brushstrokes'],
        ['buds', 'bud'],
        ['buildings', 'building'],
        ['bunnies', 'bunny'],
        ['burgandy', 'burgundy'],
        ['butterflies', 'butterfly'],
        ['buttons', 'button'],
        ['cacti', 'cactus'],
        ['campfires', 'campfire'],
        ['checked', 'check'],
        ['checker', 'check'],
        ['checker stripes', 'check'],
        ['checkered', 'check'],
        ['checkers', 'check'],
        ['checks', 'check'],
        ['Child', 'child'],
        ['circles', 'circle'],
        ['clouds', 'cloud'],
        ['collage art', 'collage'],
        ['columns', 'column'],
        ['cowboys', 'cowboy'],
        ['cows', 'cow'],
        ['cracklature', 'craquelure'],
        ['Craquelure', 'craquelure'],
        ['dancing', 'dance'],
        ['diamonds', 'diamond'],
        ['Distress', 'distressed'],
        ['dogs', 'dog'],
        ['dots', 'polka dot'],
        ['eiffle tower', 'eiffel tower'],
        ['emboss', 'embossed'],
        ['farmhouse', 'farm'],
        ['farmhouse signage', 'farm'],
        ['farmland', 'farm'],
        ['filagree', 'filigree'],
        ['filligree', 'filigree'],
        ['fleur-de-lis', 'fleur de lis'],
        ['fleur-de-lys', 'fleur de lis'],
        ['flocked', 'flock'],
        ['flocking', 'flock'],
        ['flower power', 'flower'],
        ['flowers', 'flower'],
        ['frogs', 'frog'],
        ['giraff', 'giraffe'],
        ['greek key', 'grecian'],
        ['Greek urn', 'grecian'],
        ['grungy', 'grunge'],
        ['hearts', 'heart'],
        ['hexagonal', 'hexagon'],
        ['hexagons', 'hexagon'],
        ['hills', 'hill'],
        ['holograph', 'holographic'],
        ['home sweet home', 'home'],
        ['horse and carriage', 'horse'],
        ['horses', 'horse'],
        ['keys', 'key'],
        ['kid\'s', 'kid'],
        ['kids', 'kid'],
        ['kids room', 'kid'],
        ['leopard spots', 'leopard print'],
        ['lions', 'lion'],
        ['lovers', 'love'],
        ['luxury', 'luxurious'],
        ['mansions', 'mansion'],
        ['marbled', 'marble'],
        ['marbling', 'merble'],
        ['meritime', 'nautical'],
        ['metallic', 'metal'],
        ['mirrored', 'mirror'],
        ['Monochromatic', 'monochrome'],
        ['mottled texture', 'mottled'],
        ['natural', 'nature'],
        ['night sky', 'night'],
        ['nostalgic', 'nostalgia'],
        ['ogee honey comb', 'ogee'],
        ['overay', 'overlay'],
        ['palm fronds', 'palm'],
        ['palm tree', 'palm'],
        ['palm trees', 'palm'],
        ['palms', 'palm'],
        ['parot', 'parrot'],
        ['petals', 'petal'],
        ['photographic', 'photograph'],
        ['pin stripe', 'pinstripe'],
        ['pin stripes', 'pinstripe'],
        ['pirate ship', 'pirate'],
        ['pirates', 'pirate'],
        ['planets', 'planet'],
        ['planks', 'plank'],
        ['plants', 'plant'],
        ['plaster effects', 'plaster'],
        ['polka dots', 'polka dot'],
        ['racoon', 'raccoon'],
        ['rhino', 'rhinoceros'],
        ['rhinocerus', 'rhinoceros'],
        ['ribbons', 'ribbon'],
        ['rocky', 'rock'],
        ['roses', 'rose'],
        ['scalloped', 'scallop'],
        ['scallops', 'scallop'],
        ['scrap book', 'scrapbook'],
        ['screen print', 'screenprint'],
        ['screen printed', 'screenprint'],
        ['screen printing', 'screenprint'],
        ['seashells', 'seashell'],
        ['shell', 'seashell'],
        ['shells', 'seashell'],
        ['silk screen', 'silkscreen'],
        ['skulls', 'skull'],
        ['small flower', 'flower'],
        ['small flowers', 'flower'],
        ['snowflakes', 'snow'],
        ['speckled', 'speckle'],
        ['speckles', 'speckle'],
        ['sports balls', 'sports'],
        ['squiggles', 'squiggle'],
        ['stars', 'star'],
        ['thirties', '1930s'],
        ['tiles', 'tile'],
        ['tiny flowers', 'flower'],
        ['tone on tone', 'tonal'],
        ['tone-on-tone', 'tonal'],
        ['toy cars', 'toy'],
        ['toy train', 'toy'],
        ['toys', 'toy'],
        ['trains', 'train'],
        ['tree branch', 'tree'],
        ['trees', 'tree'],
        ['triangles', 'triangle'],
        ['upholstered', 'upholstery'],
        ['vaneer', 'veneer'],
        ['vases', 'vase'],
        ['vegetables', 'vegetable'],
        ['veggie', 'vegetable'],
        ['velvet texture', 'velvet'],
        ['venetian plaster', 'plaster'],
        ['vingage', 'vintage'],
        ['water color', 'watercolor'],
        ['waves', 'wave'],
        ['wavey', 'wavy'],
        ['weatherd', 'weathered'],
        ['wethered', 'weathered'],
        ['whimsical', 'whimsy'],
        ['white washed', 'whitewash'],
        ['whitewashed', 'whitewash'],
        ['wine box', 'wine'],
        ['wine label', 'wine'],
        ['wine labels', 'wine'],
        ['wodern', 'modern'],
        ['wood paneling', 'wood panel'],
        ['wood planks', 'wood plank'],
        ['wooden', 'wood'],
        ['wovem', 'woven'],
        ['woven texture', 'woven']
    ]

    class << self

      def import item

        @valid_keywords = Keyword.all.map(&:name)

        puts 'Finding relevant information'
        vendor = Vendor.find_by!({ name: item.vendor.strip })
        product_category = ProductCategory.find_by!( { name: item.product_category.strip })
        sale_unit = SaleUnit.find_by!({ name: item.sale_unit.strip }) unless item.sale_unit.blank?
        product_types = ProductType.where(name: item.product_type.split(',').map { |t| t.strip }.reject { |c| c.empty? }) unless item.product_type.nil?
        styles = Style.where(name: item.style.split(',').map { |s| s.strip }.reject { |c| c.empty? }) unless item.style.nil?
        variant_type = VariantType.find_by!({ name: item.variant_type.strip })
        colors = Color.where(name: item.color.split(',').map { |c| c.strip }.reject { |c| c.empty? }) unless item.color.nil?

        substrate = nil
        backing_type = nil
        if item.substrate
          substrate = Substrate.find_by(name: item.substrate.strip)
          backing_type = substrate.backing_type
          if substrate.nil?
            raise "Cannot find substrate: #{item.substrate}"
          end
        elsif item.backing
          backing_type = BackingType.find_by(name: item.backing.strip)
          substrate = nil
          if backing_type.nil?
            raise "Cannot find backing type: #{item.backing}"
          end
        end

        puts 'Finding or creating collection information for '+item.collection
        collection = Collection.find_or_create_by!({ name: item.collection.strip, product_category: product_category }) do |c|
          # If we got here, this is a new record
          
          unless item.websites.nil?
            c.websites = sites_from_string item.websites, ','
          end

          if ['Digital Library'].include? c.name
            c.suppress_from_display = true
          end

          if item.respond_to?('lead_time') && item.lead_time
            c.lead_time_id = LeadTime.find_by!(name: item.lead_time.strip).id
          end
        end

        puts 'Finding or creating design information for '+item.design_name
        new_record = false
        design = Design.find_or_create_by!({ sku: item.design_sku.strip, name: item.design_name.strip, collection: collection }) do |d|
          # If we got here, this is a new record
          new_record = true

          d.available_on = Time.now
          d.styles = styles unless styles.nil?
          d.vendor = vendor
          d.websites = collection.websites

          unless item.keywords.nil?
            d.keyword_list = keyword_tag_values item.keywords
          end

          # Don't require a country of origin. This is used only for shipping via FedEx CrossBorder
          # and for some products we tell the user to call for pricing and shipping costs.
          unless item.country_of_origin.nil?
            unless country_of_origin = Country.find_by(iso: item.country_of_origin.strip)
              country_of_origin = Country.find_by(name: item.country_of_origin.strip)
            end
            d.country_of_origin = country_of_origin
          end

          # This is a duplicate of a design in another collection,
          # suppress it from display except with its collection
          if item.respond_to? 'master_sku'
            unless item.master_sku.nil?
              d.suppress_from_searches = true
              d.master_sku = item.master_sku
            end
          end

          # Custom materials should really be associated with Colorways (variants),
          # but the website only displays material options by design
          if ['Digital Library', 'Vintage', 'Pre-1920s', '1920s-1930s', '1940s-1950s', '1960s-1970s'].include? collection.name
            d.user_can_select_material = true
          end

        end

        # We can display different design descriptions on different websites
        if new_record && item.description
          item.description.split('|').map { |i| i.strip }.each do |text|

            /\A\((?<sites>.+)\)(?<site_text>.+)\z/ =~ text

            if sites
              websites = sites_from_string sites, ','
              text = site_text.strip
            else
              websites = design.websites
            end

            if text
              puts 'Processing design description: '+text
              Description.create!(
                  {
                      descriptionable_type: 'Design',
                      descriptionable_id: design.id,
                      description: text,
                      websites: websites
                  }
              )
            end

          end
        end

        # Custom materials should really be associated with Colorways (variants),
        # but the website only displays material options by design
        if ['Digital Library', 'Vintage', 'Pre-1920s', '1920s-1930s', '1940s-1950s', '1960s-1970s'].include? collection.name
          puts 'Adding custom materials'
          Substrate.where('default_custom_material_group = ?', true).each do |s|
            design.set_custom_material s
          end
        end

        puts 'Processing design properties'
        Property.all.each do |p|
          if ip = item.send(p.name)
            # puts p.presentation + ': ' + ip
            unless design.property(p.name)
              design.design_properties << DesignProperty.create(design: design, property: Property.find_by(name: p.name), value: ip)
            end
          end
        end

        variant_name = item.variant_name ? item.variant_name.strip : item.design_name.strip
        puts 'Creating variant: '+variant_name

        variant = Variant.create!(
            {
                design: design,
                variant_type: variant_type,
                name: variant_name,
                sku: item.variant_sku ? item.variant_sku.strip : item.design_sku.strip,
                backing_type: backing_type,
                product_types: product_types,
                websites: design.websites
            }
        ) do |v|
          
          # Don't require shipping information if the product is only to appear on On Air Design
          # or if we tell the user to call for pricing for products from this vendor
          # or if the item is from the Limited Stock showrrom binders
          if (item.websites.split(',').map { |w| w.strip } & %w[A H]).empty? ||
              MILLS_NOT_REQUIRING_PRICE_OR_SHIPPING_INFO.include?(item.vendor.strip) ||
              collection.name = 'Limited Stock'

            if design.digital?
              unless substrate.nil?
                v.weight = substrate.weight_per_square_foot
              end
            else
              unless item.weight.nil?
                v.weight = BigDecimal(item.weight.strip.gsub(/,/, ''), 2)
              end
            end

            unless item.package_width.nil?
              v.width = BigDecimal(item.package_width.strip.gsub(/,/, ''), 2)
            end

            unless item.package_height.nil?
              v.height = BigDecimal(item.package_height.strip.gsub(/,/, ''), 2)
            end

            unless item.package_depth.nil?
              v.depth = BigDecimal(item.package_depth.strip.gsub(/,/, ''), 2)
            end

          else

            if design.digital?
              v.weight = substrate.weight_per_square_foot
            else
              v.weight = BigDecimal(item.weight.strip.gsub(/,/, ''), 2)
            end

            v.width = BigDecimal(item.package_width.strip.gsub(/,/, ''), 2)
            v.height = BigDecimal(item.package_height.strip.gsub(/,/, ''), 2)
            v.depth = BigDecimal(item.package_depth.strip.gsub(/,/, ''), 2)

          end
          
          v.colors = colors unless colors.nil?

          if item.respond_to? 'price_code'
            v.price_code = item.price_code.strip unless item.price_code.nil?
          end

          # Don't require a price if the product is only to appear on On Air Design
          # or if we tell the user to call for pricing for products from this vendor
          # or if the item is from the Limited Stock showroom binders
          unless item.price.nil? && (
            (item.websites.split(',').map { |s| s.strip } & %w[A H]).empty? ||
              MILLS_NOT_REQUIRING_PRICE_OR_SHIPPING_INFO.include?(item.vendor.strip) ||
              collection.name = 'Limited Stock'
          )
            v.price = BigDecimal(item.price.strip.gsub(/,/, ''), 2)
          end

          v.sale_unit = sale_unit
          v.sale_quantity = item.sale_quantity.strip unless item.sale_quantity.blank?
          v.minimum_quantity = item.minimum_quantity.strip unless item.minimum_quantity.blank?

        end

        if design.digital?
          # We only offer product printed on paper on Astek Home. Matte Vinyl is the equivalent default substrate on Astek Business.
          if substrate.name == 'Paper' && item.websites.split(',').map { |w| w.strip }.include?('A')
            VariantSubstrate.create! variant: variant, substrate: Substrate.find_by(name: 'Matte Vinyl'), websites: [Website.find_by(domain: 'astek.com')]
            other_websites_string = (item.websites.split(',').map { |w| w.strip } - ['A']).join(',')
            if other_websites = sites_from_string(other_websites_string, ',')
              VariantSubstrate.create! variant: variant, substrate: substrate, websites: other_websites
            end
          else
            VariantSubstrate.create! variant: variant, substrate: substrate, websites: variant.websites
          end
        end

        item.images.split(',').map { |i| i.strip }.each do |url|
          puts 'Processing swatch image: '+url
          VariantSwatchImage.create!(
              {
                  remote_file_url: url,
                  type: 'VariantSwatchImage',
                  owner_id: variant.id
              }
          )
        end

        if item.install_images
          item.install_images.split(',').map { |i| i.strip }.each do |url|

            /\A\((?<sites>.+)\)(?<image_url>.+)\z/ =~ url

            if sites
              url = image_url.strip
              websites = sites_from_string sites, '|'
            else
              websites = variant.websites
            end

            puts 'Processing install image: '+url
            VariantInstallImage.create!(
                {
                    remote_file_url: url,
                    type: 'VariantInstallImage',
                    owner_id: variant.id,
                    websites: websites
                }
            )
          end
        end

        if collection.product_category.name == 'Digital' && variant.websites.map{ |w| w.domain }.include?('astek.com')
          puts 'Generating tearsheet'
          # This is a workaround. Accented characters seem to throw a Prawn error if read directly from the CSV file,
          # but they are OK when pulled from the database.
          v = Variant.find(variant.id)
          ::Admin::TearsheetGenerator.generate v
        end
      end

      def sites_from_string string, delimiter
        domains = []
        string.split(delimiter).map { |t| t.strip }.each do |key|
          case key
          when 'A'
            domains << 'astek.com'
          when 'H'
            domains << 'astekhome.com'
          when 'O'
            domains << 'onairdesign.com'
          end
        end
        Website.where(domain: domains)
      end

      def keyword_tag_values keywords
        keywords = keywords.split(',').map(&:strip).map(&:downcase).reject(&:empty?).uniq
        replaced = keywords.map{ |k| replace_keyword(k) }
        filter_keywords replaced
      end

      def replace_keyword keyword
        if found = KEYWORD_REPLACEMENTS.find { |l| l[0] == keyword }
          found[1]
        else
          keyword
        end
      end

      def filter_keywords keywords
        filtered = keywords.reject{ |k| @valid_keywords.exclude? k } #.uniq
      end

    end
  end
end


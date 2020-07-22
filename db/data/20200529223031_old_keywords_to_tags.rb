class OldKeywordsToTags < ActiveRecord::Migration[5.2]

  CHANGE = [
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
      ['Texute', 'textural'],
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

  def up

    @valid_keywords = Keyword.all.map(&:name)

    Collection.all.each do |c|

      if old_keywords = c.old_keywords
        if keyword_tag_values = old_keywords_to_tag_values(old_keywords)
          c.keyword_list = keyword_tag_values
          c.save!
        end
      end

      c.designs.each do |d|

        if old_keywords = d.old_keywords
          if keyword_tag_values = old_keywords_to_tag_values(old_keywords)
            d.keyword_list = keyword_tag_values
            d.save!
          end
        end

      end

    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  def old_keywords_to_tag_values old_keywords
    old = old_keywords.split(',').map(&:strip).map(&:downcase)
    replaced = old.map{ |k| replace_keyword(k) } #.reject!(&:empty?)
    filter_keywords replaced
  end

  def replace_keyword keyword
    if found = CHANGE.find { |l| l[0] == keyword }
      found[1]
    else
      keyword
    end
  end

  def filter_keywords keywords
    filtered = keywords.reject{ |k| @valid_keywords.exclude? k }.uniq
  end

end

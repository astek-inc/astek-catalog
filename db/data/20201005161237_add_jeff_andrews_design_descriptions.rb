class AddJeffAndrewsDesignDescriptions < ActiveRecord::Migration[5.2]

  DATA = [
      { sku: 'JA100', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Carved is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection.' },
      { sku: 'JA101', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Etched is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection.' },
      { sku: 'JA102', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Fired is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection.' },
      { sku: 'JA103', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Wired is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection.' },
      { sku: 'JA104', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Forged is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection.' },
      { sku: 'JA105', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Woven is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection.' },
      { sku: 'JA106', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Inked is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection.' },
      { sku: 'JA107', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Chiseled is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Chiseled is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
      { sku: 'JA108', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Diamonds is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Diamonds is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
      { sku: 'JA109', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Hourglass is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Hourglass is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
      { sku: 'JA110', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Labryinth is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Labryinth is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
      { sku: 'JA111', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Mosaic is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Mosaic is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
      { sku: 'JA112', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Pulse is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Pulse is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
      { sku: 'JA113', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Stacked is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Stacked is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
      { sku: 'JA114', description: 'Done in collaboration with celebrated interior designer Jeff Andrews, Stitched is a sophisticated pattern created from ceramic textures found in the designer\'s own pottery collection. Stitched is part of Re-Glazed, our second collaborative wallcovering collection with Jeff Andrews.' },
  ]

  def up
    DATA.each do |item|
      design = Design.find_by(sku: item[:sku])
      Description.create!(
          {
              descriptionable_type: 'Design',
              descriptionable_id: design.id,
              description: item[:description],
              websites: design.websites
          }
      )
    end
  end

  def down
    DATA.each do |item|
      design = Design.find_by(sku: item[:sku])
      Description.where({ descriptionable_type: 'Design', descriptionable_id: design.id }).destroy_all
    end
  end
end

class PopulateCollection < ActiveRecord::Migration
  def up

    category = Category.find_by(name: 'Digital Collections')
    websites = Website.where(domain: %w[designyourwall.com astekwallcovering.com])

    collection = Collection.create({
      category: category,
      name: 'Micrographia',
      description: 'Inspired by life under a microscope, Micrographia offers a new and beautiful perspective on what you thought was familiar. Through creativity, abstraction, and material exploration, Astek\'s in-house design team used far ranging media such as paint, collage, sculpture, print-making, and photography to bring their ideas to life.',
      keywords: 'mural, abstract, metallic, artistic, painterly, sci-fi, science',
      websites: websites
    })

  end

  def down

    Collection.find_by(name: 'Micrographia').destroy!

  end
end

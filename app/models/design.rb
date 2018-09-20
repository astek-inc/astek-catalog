class Design < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :collection_id

  acts_as_paranoid

  belongs_to :collection
  belongs_to :sale_unit

  has_many :variants, dependent: :destroy

  has_many :design_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  has_many :design_properties, dependent: :destroy, inverse_of: :design
  has_many :properties, through: :design_properties

  has_and_belongs_to_many :styles
  has_and_belongs_to_many :product_types

  validates :name, presence: true
  validates :sku, presence: true

  accepts_nested_attributes_for :design_properties, allow_destroy: true, reject_if: lambda { |pp| pp[:property_name].blank? }

  def property name
    self.design_properties.joins(:property).find_by(properties: { name: name }).try(:value)
  end

  def digital?
    self.collection.product_category.name == 'Digital'
  end

  def tags domain
    
    # Designs which should not show up in search results should have only the
    # tag "legacy__SKU" assigned to them. This will tell the Shopify system not
    # to display them except within their collections.
    if self.suppress_from_searches
      tags = ['legacy__SKU']
    else
      tags = []

      tags << to_tags('style', self.styles.map { |s| s.name })
      tags << to_tags('type', self.product_types.map { |t| t.name })

      if self.digital?
        tags << %w[feature__digital feature__scale feature__design feature__material feature__color]
      else
        tags << %w[feature__instock feature__lead-time feature__return-policy feature__pricing]
      end

      if self.keywords
        tags << to_tags('keyword', self.keywords.split(',')).map { |k| k.strip }
      end

      tags << to_tags('color', self.variants.map { |v| v.colors.map { |c| c.name } }.flatten.uniq)
    end

    if domain == 'astekhome.com'
      tags << self.calculator_tag
    end

    tags.flatten.join(', ')

  end

  def to_tags name, values
    tags = []
    values.each do |value|
      tags << to_tag(name, value)
    end
    tags
  end

  def to_tag name, value
    "#{name}__#{value}"
  end

  def calculator_tag
    case sale_unit.name
    when 'Roll'
      roll_width = self.property('roll_width')
      roll_length = self.property 'roll_length'

      case roll_width
      when '18'
        case roll_length
        when '16.3'
          'sold-by__RollA'
        end

      when '20.5'
        case roll_length
        when '11'
          'sold-by__RollB'
        end

      when '27'
        case roll_length
        when '9'
          'sold-by__RollC'
        when '15'
          'sold-by__RollD'
        when '11'
          'sold-by__RollE'
        end

      when '36'
        case roll_length
        when '16.3'
          'sold-by__RollF'
        when '8'
          if self.minimum_quantity == 3
            'sold-by__RollGMin3'
          else
            'sold-by__RollG'
          end
        when '11'
          'sold-by__RollH'
        when '12'
          'sold-by__RollI'
        end

      when '39'
        case roll_length
        when '11'
          if self.minimum_quantity == 3
            'sold-by__RollJMin3'
          else
            'sold-by__RollJ'
          end
        when '22.9659'
          # This is by meter, it needs a separate sale unit
          'sold-by__RollK'
        end
      end

    when 'Yard'
      roll_width = self.property('roll_width')
      roll_length = self.property 'roll_length'

      case roll_width
      when '36'
        case roll_length
        when '55'
          if self.minimum_quantity == 4
            'sold-by__YardAMin4'
          else
            'sold-by__YardA'
          end
        end
      when '48'
        case roll_length
        when '55'
          if self.minimum_quantity == 4
            'sold-by__YardBMin4'
          else
            'sold-by__YardB'
          end
        end
      when '54'
        case roll_length
        when '10','55'
          case self.minimum_quantity
          when 4
            'sold-by__YardCMin4'
          when 6
            'sold-by__YardCMin6'
          when 10
            'sold-by__YardCMin10'
          else
            'sold-by__YardC'
          end
        end
      end

    when 'Meter'
      roll_width = self.property('roll_width')
      # roll_length = self.property 'roll_length'

      case roll_width
      when '39'
        if self.minimum_quantity == 10
          'sold-by__MeterAMin10'
        else
          'sold-by__MeterA'
        end
      end

    when 'Square Foot'
      'sold-by__CustomA'
    end
  end

end

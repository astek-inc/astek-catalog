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
    self.product_types.map { |t| t.product_category.name }.include? 'Digital'
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
      tags << to_tag('type', self.product_type.name)

      if self.product_type.product_category.name == 'Digital'
        tags << %w[feature__digital feature__scale feature__design feature__material feature__color]
      end

      if self.keywords
        tags << to_tags('keyword', self.keywords.split(',')).map { |k| k.strip }
      end

      tags << self.design_properties.map { |dp| to_tag(dp.property.presentation, dp.value) }
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
          'sold-by__RollG'
        when '11'
          'sold-by__RollH'
        when '12'
          'sold-by__RollI'
        end

      when '39'
        case roll_length
        when '11'
          'sold-by__RollJ'
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
          'sold-by__YardA'
        end
      when '48'
        case roll_length
        when '55'
          'sold-by__YardB'
        end
      when '54'
        case roll_length
        when '10','55'
          'sold-by__YardC'
        end
      end

    when 'Meter'
      roll_width = self.property('roll_width')
      # roll_length = self.property 'roll_length'

      case roll_width
      when '39'
        'sold-by__MeterA'
      end

    when 'Square Foot'
      'sold-by__CustomA'
    end
  end

end

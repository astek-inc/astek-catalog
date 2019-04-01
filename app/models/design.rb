class Design < ApplicationRecord

  resourcify

  include RankedModel
  ranks :row_order, with_same: :collection_id

  acts_as_paranoid

  scope :available, -> { where('expires_on IS NULL OR expires_on >= NOW()') }

  belongs_to :collection
  belongs_to :vendor, inverse_of: :designs
  belongs_to :sale_unit
  belongs_to :country_of_origin, class_name: 'Country', foreign_key: 'country_id'

  has_many :variants, -> { order(row_order: :asc) }, dependent: :destroy

  has_many :design_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

  has_many :design_properties, dependent: :destroy, inverse_of: :design
  has_many :properties, through: :design_properties

  has_and_belongs_to_many :styles

  # Custom materials should really be associated with Colorways (variants),
  # but the website only displays material options by design
  has_many :custom_materials, dependent: :destroy, inverse_of: :design
  has_many :substrates, through: :custom_materials

  validates :name, presence: true
  validates :sku, presence: true

  accepts_nested_attributes_for :design_properties, allow_destroy: true, reject_if: lambda { |pp| pp[:property_name].blank? }

  def install_images
    self.variants.map { |v| v.variant_install_images.first.nil? ? nil : { variant_id: v.id, install_image: v.variant_install_images.first } }.compact
  end

  def property name
    self.design_properties.joins(:property).find_by(properties: { name: name }).try(:value)
  end

  def set_property name, value
      property = Property.find_by(name: name)
      design_property = DesignProperty.where(design: self, property: property).first_or_initialize
      design_property.value = value
      design_property.save!
  end

  def delete_property name
    if dp = self.design_properties.joins(:property).find_by(properties: { name: name })
      dp.destroy
    end
  end

  def set_custom_material substrate
    CustomMaterial.find_or_create_by!(design: self, substrate: substrate, default_material: substrate.name == 'Paper')
  end

  def available?
    self.expires_on.nil? || self.expires_on > Time.now
  end

  def digital?
    self.collection.product_category.name == 'Digital'
  end

  def has_colorways?
    self.variants.map { |v| v.variant_type.name }.include? 'Color Way'
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
      tags << to_tags('type', self.variants.map { |v| v.product_types.select { |t| t.websites.map { |w| w.domain }.include?(domain) }.map { |t| t.name.downcase } }.flatten.uniq)

      if domain == 'astek.com'
        if self.digital?
          tags << %w[feature__digital feature__scale feature__design feature__material feature__color]
        else
          tags << %w[feature__instock feature__return-policy feature__pricing]
          tags << "feature__lead-time-#{self.collection.lead_time.name.parameterize}"
        end
      end

      if self.keywords
        tags << to_tags('keyword', self.keywords.split(',').map { |k| k.strip }.reject { |k| k.empty? })
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
    "#{name}__#{value.strip}"
  end

  def calculator_tag
    case sale_unit.name
    when 'Roll'
      roll_width = self.property('roll_width_inches')
      roll_length = self.property('roll_length_yards')

      case roll_width

      when '1.25'
        case roll_length
        when '11'
          'sold-by__RollAG'
        end

      when '1.625'
        case roll_length
        when '11'
          'sold-by__RollX'
        end

      when '2.75'
        case roll_length
        when '11'
          'sold-by__RollW'
        end

      when '10.5'
        case roll_length
        when '11'
          'sold-by__RollAD'
        end

      when '10.625'
        case roll_length
        when '11'
          'sold-by__RollAF'
        end

      when '10.8125'
        case roll_length
        when '11'
          'sold-by__RollAJ'
        end

      when '11'
        case roll_length
        when '11'
          'sold-by__RollAE'
        end

      when '11.0625'
        case roll_length
        when '11'
          'sold-by__RollAC'
        end

      when '11.125'
        case roll_length
        when '11'
          'sold-by__RollAK'
        end

      when '17.72'
        case roll_length
        when '5.47'
          'sold-by__RollO'
        when '10.94'
          'sold-by__RollP'
        when '16.4'
          'sold-by__RollA'
        end

      when '20.5'
        case roll_length
        when '11'
          'sold-by__RollB'
        end

      when '20.5625'
        case roll_length
        when '11'
          'sold-by__RollAL'
        end

      when '20.8125'
        case roll_length
        when '11'
          'sold-by__RollAH'
        end

      when '20.875'
        case roll_length
        when '11'
          'sold-by__RollZ'
        end

      when '20.9375'
        case roll_length
        when '11'
          'sold-by__RollY'
        end

      when '21'
        case roll_length
        when '11'
          'sold-by__RollU'
        end

      when '21.0625'
        case roll_length
        when '11'
          'sold-by__RollAA'
        end

      when '21.125'
        case roll_length
        when '11'
          'sold-by__RollV'
        end

      when '21.1875'
        case roll_length
        when '11'
          'sold-by__RollAI'
        end

      when '21.25'
        case roll_length
        when '11'
          'sold-by__RollAB'
        end

      when '21.3'
        case roll_length
        when '10'
          'sold-by__RollAN'
        end

      when '22'
        case roll_length
        when '10'
          'sold-by__RollAO'
        end

      when '24'
        case roll_length
        when '8'
          'sold-by__RollS'
        when '11'
          'sold-by__RollAM'
        end

      when '26.57'
        case roll_length
        when '10.94'
          'sold-by__RollQ'
        end

      when '27'
        case roll_length
        when '9'
          'sold-by__RollC'
        when '15'
          'sold-by__RollD'
        end

      when '27.55'
        case roll_length
        when '11'
          'sold-by__RollE'
        end

      when '30'
        case roll_length
        when '15'
          'sold-by__RollN'
        end

      when '35.43'
        case roll_length
        when '10.94'
          'sold-by__RollR'
        when '16.4'
          'sold-by__RollF'
        end

      when '36'
        case roll_length
        when '6'
          'sold-by__RollM'
        when '8'
          if self.minimum_quantity == 3
            'sold-by__RollTMin3'
          else
            'sold-by__RollG'
          end
        when '11'
          'sold-by__RollH'
        when '12'
          if self.minimum_quantity == 3
            'sold-by__RollIMin3'
          end
        end

      when '39'
        case roll_length
        when '11'
          if self.minimum_quantity == 3
            'sold-by__RollJMin3'
          end
        when '22.9659'
          # This is by meter, it needs a separate sale unit
          'sold-by__RollK'
        end

      when '40.5'
        case roll_length
        when '7.5'
          'sold-by__RollL'
        end
      end

    when 'Yard'
      roll_width = self.property('roll_width_inches')

      case roll_width
      when '35'
        if self.minimum_quantity == 4
          'sold-by__YardEMin4'
        end
      when '36'
        if self.minimum_quantity == 4
          'sold-by__YardAMin4'
        end
      when '37'
        if self.minimum_quantity == 4
          'sold-by__YardFMin4'
          end
      when '38'
        if self.minimum_quantity == 4
          'sold-by__YardGMin4'
        end
      when '48'
        if self.minimum_quantity == 4
          'sold-by__YardBMin4'
        end
      when '49'
        if self.minimum_quantity == 4
          'sold-by__YardHMin4'
        end
      when '54'
        case self.minimum_quantity
        when 4
          'sold-by__YardCMin4'
        when 10
          'sold-by__YardDMin10'
        end
      end

    when 'Meter'
      roll_width = self.property('roll_width_inches')
      # roll_length = self.property 'roll_length_meters'

      case roll_width
      when '39'
        if self.minimum_quantity == 10
          'sold-by__MeterAMin10'
        else
          'sold-by__MeterA'
        end
      end

    when 'Square Foot'
      if self.minimum_quantity == 30
        'sold-by__CustomAMin30'
      end
    end
  end

end

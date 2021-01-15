class StockItem < ApplicationRecord

  resourcify

  acts_as_paranoid

  include Websiteable

  belongs_to :variant, inverse_of: :stock_items
  belongs_to :substrate, optional: true
  belongs_to :backing_type, optional: true
  belongs_to :sale_unit, optional: true

  # default_scope { order(name: :asc) }

  def substrate_or_backing
    if self.substrate.present?
      self.substrate.name
    elsif self.backing_type.present?
      self.backing_type.name
    end
  end

  def calculator_settings

    case self.sale_unit.name
    when 'Roll'
      width = self.variant.design.property('roll_width_inches')
      if length = self.variant.design.property('roll_length_yards')
        {
          note: "Indicate no. of Rolls <span>(1 Roll = #{width} in. x #{length} yd.)</span>",
          divisor: (BigDecimal(width, 9) * (BigDecimal(length, 9) * BigDecimal('36', 9))),
          minimum: self.minimum_quantity,
          sale_unit: %w[roll rolls]
        }.to_json
      elsif length = self.variant.design.property('roll_length_feet')
        {
          note: "Indicate no. of Rolls <span>(1 Roll = #{width} in. x #{length} ft.)</span>",
          divisor: (BigDecimal(width, 9) * (BigDecimal(length, 9) * BigDecimal('12', 9))),
          minimum: self.minimum_quantity,
          sale_unit: %w[roll rolls]
        }.to_json
      end

    when 'Yard'
      width = self.variant.design.property('roll_width_inches')
      length = '36'

      parenthetical_note = "#{width} in. wide roll, sold per yard."
      if self.minimum_quantity > 1
        parenthetical_note += " This product has a minimum order quantity of #{self.minimum_quantity} yards."
      end

      {
        note: "Indicate no. of Yards <span>(#{parenthetical_note})</span>",
        divisor: (BigDecimal(width, 9) * BigDecimal(length, 9)),
        minimum: self.minimum_quantity,
        sale_unit: %w[yard yards]
      }.to_json

    when 'Meter'
      width = self.variant.design.property('roll_width_inches')
      length = '39.37'

      parenthetical_note = "#{width} in. wide roll, sold per meter."
      if self.minimum_quantity > 1
        parenthetical_note += " This product has a minimum order quantity of #{self.minimum_quantity} meters."
      end

      {
        note: "Indicate no. of Meters <span>(#{parenthetical_note})</span>",
        divisor: (BigDecimal(width, 9) * BigDecimal(length, 9)),
        minimum: self.minimum_quantity,
        sale_unit: %w[meter meters]
      }.to_json

    when 'Square Foot'
      {
        note: "Indicate no. of Square Feet<br><span>This product is custom printed. Minimum order quantity of #{self.minimum_quantity} square feet. We suggest adding an additional 20-30% overage to be sure you're covered!</span>",
        divisor: 144,
        minimum: self.minimum_quantity,
        sale_unit: ['square foot', 'square feet']
      }.to_json

    when 'Set'

      # If we have dimensions for the whole mural, we'll use those. Otherwise,
      # we'll use the dimensions of each panel and multiply by the number of panels.
      if (self.variant.design.property('mural_width_inches') && self.variant.design.property('mural_height_inches'))
        width = self.variant.design.property('mural_width_inches')
        height = self.variant.design.property('mural_height_inches')
        divisor = BigDecimal(width, 9) * BigDecimal(height, 9)
      else
        width = self.variant.design.property 'panel_width_inches'
        height = self.variant.design.property 'panel_height_inches'
        quantity = self.variant.design.property 'panels_per_set'
        divisor = (BigDecimal(width, 9) * BigDecimal(height, 9) * BigDecimal(quantity, 9))
      end

      {
        note: "Indicate no. of Sets of #{quantity} Panels<br><span>Minimum order quantity of #{self.minimum_quantity} set. We suggest adding an additional 20-30% overage to be sure you're covered!</span>",
        divisor: divisor,
        minimum: self.minimum_quantity,
        sale_unit: ['set', 'sets']
      }.to_json

    when 'Panel'
      width = self.variant.design.property 'panel_width_inches'
      height = self.variant.design.property 'panel_height_inches'
      {
        note: "Indicate no. of Panels<br><span>We suggest adding an additional 20-30% overage to be sure you're covered!</span>",
        divisor: (BigDecimal(width, 9) * BigDecimal(height, 9)),
        minimum: self.minimum_quantity,
        sale_unit: ['panel', 'panels']
      }.to_json
    end

  end

end

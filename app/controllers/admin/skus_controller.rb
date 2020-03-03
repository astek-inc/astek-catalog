module Admin
  class SkusController < Admin::BaseController

    def next_available
      @sku_prefixes = SkuPrefix.all
    end

    def find_next_available

      @prefix = SkuPrefix.find(params[:sku_prefix][:id])
      @next_available_sku = Design.next_available_sku @prefix
    end

    def validate

    end

    def validation
      @skus = params[:skus].split(/\s*[\s+,]\s*/)
      found = Design.where(sku: @skus).map { |d| d.sku }
      @result = []
      @skus.each do |sku|
        @result << { sku: sku, found: found.include?(sku) }
      end
    end

  end
end

module KeywordValidateable
  extend ActiveSupport::Concern

  included do
    validate :must_have_valid_keywords
  end

  def must_have_valid_keywords
    valid_keywords = Keyword.all.map(&:name)
    invalid_keywords = keyword_list - valid_keywords
    if invalid_keywords.any?
      errors.add(:keyword_list, "contains unknown keywords: #{invalid_keywords.join(', ')}")
    end
  end

end
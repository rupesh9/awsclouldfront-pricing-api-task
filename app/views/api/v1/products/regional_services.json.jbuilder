json.array!(@products) do |product|
  json.description           product.description
  json.beginRange            product.begin_range
  json.unit                  product.unit
  json.pricePerUnit          product.price_per_unit
  json.effectiveDate         product.effective_date
end
desc "Checking and saving updated Cloud Front Pricing"

task :update_cf_pricing_data => [:environment] do
  require 'net/http'

  REGION_MAPPING = {
    'Middle East' => 'me-south-1',
    'India'  => 'ap-south-1',
    'South America' =>  'sa-east-1',
    'United States' => 'us-east-1',
    'Europe' => 'eu-west-1', 
    'Canada' => 'ca-central-1 ',
    'Japan' => 'ap-northeast-1',
    'Australia' => 'ap-southeast-2',
    'Asia Pacific' => 'ap-southeast-1'
  }

  url = 'https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonCloudFront/current/index.json'
  response = Net::HTTP.get(URI.parse(url))
  result = JSON.parse response

  result['products'].each do |aws_product|

    id = aws_product.first
    product = Product.where(aws_id: id).order(created_at: :desc).first
    price_per_unit = result["terms"]["OnDemand"][id].first[1]["priceDimensions"].first[1]["pricePerUnit"].first[1]
    next if product.present? && product.price_per_unit ==  price_per_unit

    attributes = aws_product.last['attributes']
    location = attributes['location']

    region = Region.where(code: REGION_MAPPING[location]).first
    next unless region 
    service_code = attributes['servicecode']
    service_name = attributes['servicename']
    service = Service.where(name: service_name, code: service_code).first
    next unless service
    effective_date = result['terms']['OnDemand'][id].first[1]['effectiveDate']
    description = result['terms']['OnDemand'][id].first[1]['priceDimensions'].first[1]['description']
    begin_range = result['terms']['OnDemand'][id].first[1]['priceDimensions'].first[1]['beginRange']
    end_range = result['terms']['OnDemand'][id].first[1]['priceDimensions'].first[1]['endRange']
    unit = result['terms']['OnDemand'][id].first[1]['priceDimensions'].first[1]['pricePerUnit'].first[0]
    Product.create(aws_id: id, description: description, begin_range: begin_range,
                    end_range: end_range, unit: unit, price_per_unit: price_per_unit,
                    effective_date: effective_date, region_id: region.id, 
                    service_id: service.id  
                  )
    puts "Product Created \t desc \t #{description} "
  end
end


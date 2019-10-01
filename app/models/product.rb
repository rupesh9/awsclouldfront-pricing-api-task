class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_ai, as: :aws_id, type: String
  field :_ds, as: :description, type: String
  field :_br, as: :begin_range, type: String
  field :_er, as: :end_range, type: String
  field :_ui, as: :unit, type: String
  field :_cd, as: :price_per_unit, type: String
  field :_ed, as: :effective_date, type: String

  belongs_to :region, class_name: "Region", inverse_of: :products, index: true
  belongs_to :service, class_name: "Service", inverse_of: :products, index: true
end

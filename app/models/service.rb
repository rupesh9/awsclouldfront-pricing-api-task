class Service
  include Mongoid::Document

  field :_n, as: :name, type: String
  field :_sc, as: :code, type: String

  has_many :products, class_name: "Product", inverse_of: :service

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end
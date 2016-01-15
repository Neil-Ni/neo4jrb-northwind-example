class Order 
  include Neo4j::ActiveNode

  property :order_date, type: DateTime
  property :required_date, type: DateTime
  property :shipped_date, type: String
  property :ship_via, type: String
  property :freight, type: String
  property :ship_name, type: String
  property :ship_address, type: String
  property :ship_city, type: String
  property :ship_region, type: String
  property :ship_postal_code, type: String
  property :ship_country, type: String

  property :created_at
  property :updated_at

  has_one :in, :customer, origin: :orders
  has_many :out, :products, rel_class: :Contain
end

class Product
  include Neo4j::ActiveNode

  property :name, type: String
  property :quantity_per_unit, type: Integer
  property :unit_price, type: Integer
  property :units_in_stock, type: Integer
  property :units_on_order, type: Integer
  property :reorder_level, type: Integer
  property :discontinued, type: Boolean

  property :created_at
  property :updated_at

  has_one  :out, :category, type: :PART_OF
  has_many :in, :suppliers, origin: :products
  has_many :in, :order, origin: :products
end

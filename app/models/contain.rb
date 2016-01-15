class Contain
  include Neo4j::ActiveRel

  from_class :Order
  to_class :Product
  type :CONTAINS

  property :quantity, type: Float

  property :created_at
  property :updated_at
end

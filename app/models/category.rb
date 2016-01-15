class Category 
  include Neo4j::ActiveNode

  property :name, constraint: :unique
  property :description, type: String
  property :picture, type: String

  has_many :in, :products, origin: :categories

  property :created_at
  property :updated_at
end

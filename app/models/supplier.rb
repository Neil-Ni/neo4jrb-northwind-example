class Supplier 
  include Neo4j::ActiveNode

  property :company_name, type: String
  property :contact_name, type: String
  property :contact_title, type: String
  property :address, type: String
  property :city, type: String
  property :region, type: String
  property :postal_code, type: String
  property :country, type: String
  property :phone, type: String
  property :fax, type: String
  property :home_page, type: String

  property :created_at
  property :updated_at

  has_many :out, :products, type: :SUPPLIES
end

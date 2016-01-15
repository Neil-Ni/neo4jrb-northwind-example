task neo4j_db_drop: :environment do
  puts 'Are you SURE you want to wipe your Neo4j database?'
  print "#{Rails.env} environment (y/n)? > "
  exit! unless %w(y yes).include?(STDIN.gets.chomp.downcase)

  Neo4j::Session.current.query('MATCH n OPTIONAL MATCH n-[r]-() DELETE n, r')

  puts 'Done!'
end


task neo4j_db_seed: :environment do

  puts 'Creating (:Category) Nodes'
  csv_data   = CSV.table(Rails.root.join('db', 'categories.csv'))
  categories = {}
  csv_data.each do |row|
    category = Category.create(
      name: row[:categoryname],
      description: row[:description],
      picture: row[:picture]
    )
    categories[row[:categoryid]] = category
  end

  puts 'Creating (:Supplier) Nodes'
  csv_data   = CSV.table(Rails.root.join('db', 'suppliers.csv'))
  suppliers = {}
  csv_data.each do |row|
    supplier = Supplier.create(
      company_name: row[:companyname],
      contact_name: row[:contactname],
      contact_title: row[:contacttitle],
      address: row[:address],
      city: row[:city],
      region: row[:region],
      postal_code: row[:postalcode],
      country: row[:country],
      phone: row[:phone],
      fax: row[:fax],
      home_page: row[:homepage]
    )
    suppliers[row[:supplierid]] = supplier
  end

  puts 'Creating (:Product) Nodes'
  csv_data   = CSV.table(Rails.root.join('db', 'products.csv'))
  products = {}
  csv_data.each do |row|
    product = Product.create(
      name: row[:productname],
      unit_price: row[:unitprice],
      units_in_stock: row[:unitsinstock],
      units_on_order: row[:unitsonorder],
      reorder_level: row[:reorderlevel],
      discontinued: row[:discontinued] == 0
    )
    product.category = categories[row[:categoryid]]
    product.suppliers << suppliers[row[:supplierid]]
    products[row[:productid]] = product
  end

  puts 'Creating (:Customer) Nodes'
  csv_data   = CSV.table(Rails.root.join('db', 'customers.csv'))
  customers = {}
  csv_data.each do |row|
    customer = Customer.create(
      company_name: row[:companyname],
      contact_name: row[:contactname],
      contact_title: row[:contacttitle],
      address: row[:address],
      city: row[:city],
      region: row[:region],
      postal_code: row[:postalcode],
      country: row[:country],
      phone: row[:phone],
      fax: row[:fax]
    )
    customers[row[:customerid]] = customer
  end

  puts 'Creating (:Order) Nodes'
  csv_data   = CSV.table(Rails.root.join('db', 'orders.csv'))
  orders = {}
  csv_data.each do |row|
    order = Order.create(
      order_date: row[:orderdate],
      required_date: row[:requireddate],
      shipped_date: row[:shippeddate],
      ship_via: row[:shipvia],
      freight: row[:freight],
      ship_name: row[:shipname],
      ship_address: row[:shipaddress],
      ship_city: row[:shipcity],
      ship_region: row[:shipregion],
      ship_postal_code: row[:shippostalcode],
      ship_country: row[:shipcountry]
    )
    order.customer = customers[row[:customerid]]
    orders[row[:orderid]] = order
  end

  puts 'Creating [:CONTAINS] Relationships (Ex: (:Order) - [:CONTAINS] -> (:Product))'
  csv_data   = CSV.table(Rails.root.join('db', 'order-details.csv'))
  csv_data.each do |row|
    if orders[row[:orderid]] && products[row[:productid]]
      Contain.create(
        from_node: orders[row[:orderid]],
        to_node: products[row[:productid]],
        quantity: row[:quantity]
      )
    end
  end
end

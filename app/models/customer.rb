class Customer < Account
  
  # belongs_to :user
  # has_many :contacts
  # has_many :equipment, :class_name => "Equipment"
  # has_many :charges
  # has_many :receipts
  # has_many :payment_plans
  # has_many :invoices
  # has_many :credit_cards
  # has_many :orders
  
  
  def payment_terms
    90
  end
  
end
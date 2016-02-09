class Order < ActiveRecord::Base
  
  include ApplicationHelper
  
  default_scope { order(:id) }
  #default_scope { self.open }
  
  scope :locked, -> () { where(:locked => true) }
  scope :has_account, -> () { where(:account_id => !nil) }
  scope :no_account, -> () { where(:account_id => !nil) }
  has_many :order_line_items
  has_one :order_shipping_method
  belongs_to :account
  has_many :items, :through => :order_line_items
  
  accepts_nested_attributes_for :order_line_items, :allow_destroy => true
  
  before_save :make_record_number
  # before_save :make_total
  
  def self.open
    Order.joins(:order_line_items).distinct(:order_id)
    # Order.all.select { |o| o.has_line_items }
  end
  
  def self.empty
    Order.all.select { |o| o.has_no_line_items }
  end
  
  def has_line_items
    order_line_items.count >= 1
  end
  
  def has_no_line_items
    order_line_items.count == 0
  end
  
  def sub_total
    total = 0
    order_line_items.find_each {|ol| total += ol.sub_total}
    total
  end
  
  def shipping_total
    order_shipping_method.amount unless order_shipping_method.nil?
  end
  
  def total
    sub_total.to_f + shipping_total.to_f
  end
  
  def quantity_shipped
    if self.order_line_items
      total = 0
      self.order_line_items.each {|i| total = i.quantity_shipped }
      total
    end
  end
  
  def amount_shipped
    if self.order_line_items
      total = 0
      self.order_line_items.each {|i| total = (i.quantity_shipped * i.price) }
      total
    end
  end
  
  # def make_subtotal
  #   self.sub_total = 0.0
  #   self.order_line_items.each {|q| self.sub_total = (self.sub_total.to_f + q.sub_total.to_f) }
  # end
  
  # def make_total
  #   make_subtotal
  #   self.total = (self.sub_total.to_f - self.discount.to_f + self.freight.to_f + self.tax.to_f)
  # end
  
end

class PaymentPlanTemplatesController < ApplicationController
  layout "admin"
  
  def index
    @plans = PaymentPlanTemplate.all
  end
  
  def new
    @plan = PaymentPlanTemplate.new
  end
  
  def create
    @plan = PaymentPlanTemplate.new(registration_params.merge(:name => params[:payment_plan_template][:name], :amount => params[:payment_plan_template][:amount]))
    if @plan.save
      redirect_to payment_plan_templates_path
    else
      render :new
    end
  end
  
  private
  
  def registration_params
    params.require(:payment_plan_template).permit(:name, :amount)
  end
  
end
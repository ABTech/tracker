module ApplicationHelper
  
  def conditional_link_to(title, url, action, model)
    link_to title, url if can? action, model
  end
  
  def conditional_link_to_remote(title, url, action, model)
    link_to title, url, :remote => true if can? action, model
  end
  
  def conditional_link_to_delete(title, url, action, model)
    link_to title, url, :method => :delete, :data => { :confirm => "Are you sure you want to delete this? This action is irreversible." } if can? action, model
  end
  
  def text_with_conditional_link_to(title, url, action, model)
    if can? action, model
      link_to title, url
    else
      title
    end
  end
  
  def show_admin_link
    can? :read, Equipment or can? :read, Location or can? :read, Timecard or can? :read, InvoiceItem or can? :read, EmailForm or can? :read, Blackout
  end

  Date.class_eval do
    def ago
      return "today" if Date.today-self == 0 
      return "yesterday" if Date.today-self == 1
      return "tomorrow" if Date.today-self == -1
      return (Date.today-self).to_s+" days ago" if Date.today-self > 0
      return "in "+(self-Date.today).to_s+" days" if Date.today-self < 0
    end
  end

  def app_version
    begin
      %x{git log --pretty=format:"%h"  -n1}
    rescue
      "?"
    end
  end
  
  def load_account_totals
    @accstart = Account.magic_date unless @accstart
    @accend = Account.future_magic_date unless @accend

    @accounts_receivable_total = Journal.where("date >= ? AND date < ? AND date_paid IS NULL AND account_id in (?)", @accstart, @accend, Account::Credit_Accounts.pluck(:id)).sum(:amount)
    @accounts_received_total = Journal.where("date >= ? AND date < ? AND date_paid IS NOT NULL AND account_id in (?)", @accstart, @accend, Account::Credit_Accounts.pluck(:id)).sum(:amount)
    @accounts_payable_total = Journal.where("date >= ? AND date < ? AND date_paid IS NULL AND account_id in (?)", @accstart, @accend, Account::Debit_Accounts.pluck(:id)).sum(:amount)
    @accounts_paid_total = Journal.where("date >= ? AND date < ? AND date_paid IS NOT NULL AND account_id in (?)", @accstart, @accend, Account::Debit_Accounts.pluck(:id)).sum(:amount)

    @credit_JEs = Journal.where("date >= ? AND date < ? AND account_id in (?)", @accstart, @accend, Account::Credit_Accounts.pluck(:id))
    @debit_JEs = Journal.where("date >= ? AND date < ? AND account_id in (?)", @accstart, @accend, Account::Debit_Accounts.pluck(:id))
    
    @credit_categories = Journal.select("SUM(amount) AS amount, paymeth_category").where("date >= ? AND date < ? AND account_id in (?)", @accstart, @accend, Account::Credit_Accounts.pluck(:id)).group(:paymeth_category)
    @debit_categories = Journal.select("SUM(amount) AS amount, paymeth_category").where("date >= ? AND date < ? AND account_id in (?)", @accstart, @accend, Account::Debit_Accounts.pluck(:id)).group(:paymeth_category)

    @cat_totals = Hash.new(0)

    @credit_categories.each do |category|
      @cat_totals[category.paymeth_category]+=category.amount
    end

    @debit_categories.each do |category|
      @cat_totals[category.paymeth_category]-=category.amount
    end
  end
  
  def better_select_date(startdate, object, field)
      return select_year(startdate, :prefix => "#{object}[#{field}(1i)]", :discard_type => true) + 
             select_month(startdate, :prefix => "#{object}[#{field}(2i)]", :discard_type => true) + 
             select_day(startdate, :prefix => "#{object}[#{field}(3i)]", :discard_type => true)
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "delete_field", onClick: "return false")
  end
  
  def link_to_add_fields(name, f, association, extra="", controller="", locals={})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(controller + "/" + association.to_s.singularize + "_fields", locals.merge(:f => builder))
    end
    link_to(name, "#", class:"add_field"+extra, data: {association: "#{association}", content: "#{fields}"}, onClick: "return false")
  end
  
  def link_to_add_eventdate_fields(name, f)
    new_object = f.object.class.reflect_on_association(:eventdates).klass.new
    new_object.event_roles.build
    fields = f.fields_for(:eventdates, new_object, :child_index => "new_eventdates") do |builder|
      render("events/eventdate_fields", {:f => builder})
    end
    link_to(name, "#", class:"add_field", data: {association: "eventdates", content: "#{fields}"}, onClick: "return false")
  end
end

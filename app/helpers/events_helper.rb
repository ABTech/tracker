module EventsHelper
  def my_comment?(member)   
    member==current_member
  end
  
  def organizations_for_select
    Organization.order("name ASC").all.to_a.map do |org|
      [org.name, org.id]
    end
  end
  
  def statuses_for_select
    Event::Event_Status_Group_All.map do |status|
      [status, status]
    end
  end
  
  def roles_for_select
    ([""] | EventRole::Roles_All).map do |role|
      [role, role]
    end
  end
  
  def members_for_select(role)
    ([["unassigned", ""]] | Member.order("namefirst ASC, namelast ASC").all.to_a.map do |member|
      [member.fullname, member.id]
    end)
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "delete_field", onClick: "return false")
  end
  
  def link_to_add_fields(name, f, association, extra="")
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("events/" + association.to_s.singularize + "_fields", :f => builder)
    end
    link_to(name, "#", class:"add_field"+extra, data: {association: "#{association}", content: "#{fields}"}, onClick: "return false")
  end
end

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
end

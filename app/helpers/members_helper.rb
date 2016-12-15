module MembersHelper
  def pretty_phone(number)
    link_to (number_to_phone number, :delimiter => "."), "tel:+1" + number
  end

  def table_order_link(text, order_key, order, order_desc, params)
    if order == order_key
      if order_desc
        text += ' ' + image_tag('sort_up.gif', class: "order", alt: "&uarr;")
      else
        text += ' ' + image_tag('sort_down.gif', class: "order", alt: "&darr;")
      end
      
      link_to text.html_safe, params.merge(order: order_key, desc: (order_desc ? 0 : 1))
    else
      text += ' ' + image_tag('sort_none.gif', class: "order", alt: "&harr;")
      
      link_to text.html_safe, params.merge(order: order_key, desc: 0)
    end
  end
  
  def bulk_members_for_select
    Member.role.values.reverse.map do |role|
      [Member.new(:role => role).role_text, Member.with_role(role).alphabetical.map do |m|
        [m.display_name, m.id]
      end]
    end.reject do |role|
      role[1].size == 0
    end
  end
end

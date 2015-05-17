module EquipmentHelper
  
  def equipment_groups_for_select
    results = []
    
    Equipment.categories.each do |c|
      unless Equipment.category(c).empty?
        results << [
          c,
          Equipment.category(c).collect do |cc|
            [cc.description, cc.id]
          end
        ]
      end
      
      Equipment.subcategories(c).each do |sc|
        results << [
          "#{c} - #{sc}",
          Equipment.subcategory(c, sc).collect do |scc|
            [scc.description, scc.id]
          end
        ]
      end
    end
    
    results
  end
  
  def equipment_categories_for_select
    safe_join(Equipment.categories.collect do |e|
      content_tag(:option, e, {:value => e, :data => {:subcategories => "" + options_for_select(Equipment.subcategories(e)) }})
    end,"")
  end
  
end

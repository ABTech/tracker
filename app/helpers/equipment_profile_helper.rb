module EquipmentProfileHelper
  
  def equipment_profile_groups_for_select
    results = []
    
    EquipmentProfile.categories.each do |c|
      unless EquipmentProfile.category(c).empty?
        results << [
          c,
          EquipmentProfile.category(c).collect do |cc|
            [cc.description, cc.id]
          end
        ]
      end
      
      EquipmentProfile.subcategories(c).each do |sc|
        results << [
          "#{c} - #{sc}",
          EquipmentProfile.subcategory(c, sc).collect do |scc|
            [scc.description, scc.id]
          end
        ]
      end
    end
    
    results
  end
  
  def equipment_profile_categories_for_select
    safe_join(EquipmentProfile.categories.collect do |e|
      content_tag(:option, e, {:value => e, :data => {:subcategories => "" + options_for_select(EquipmentProfile.subcategories(e)) }})
    end,"")
  end
  
end

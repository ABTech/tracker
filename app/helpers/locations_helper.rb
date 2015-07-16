module LocationsHelper
  
  def location_groups_for_select
    Location.buildings.collect do |b|
      [b,
        Location.building(b).collect do |cc|
          [cc.room, cc.id]
        end
      ]
    end
  end
  
end

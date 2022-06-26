class KioskAbility
  include CanCan::Ability

  def initialize(kiosk)
    kiosk ||= Kiosk.new()

    # Already public options
    can :index, Event
    can :eventrequest, Event

    if kiosk.ability_read_equipment
      can :read, EquipmentProfile
    end

    if kiosk.ability_index_weather
      can :index, WeatherController
    end
  end
end

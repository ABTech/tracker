class KioskAbility
  include CanCan::Ability

  def initialize(kiosk)
    kiosk ||= Kiosk.new()

    # Already public options
    can :index, Event
    can :eventrequest, Event
  end
end

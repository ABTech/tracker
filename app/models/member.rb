class Member < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :encryptable, :encryptor => :restful_authentication_sha1, :authentication_keys => [:login]
  
  has_many :event_roles
  has_many :comments
  has_many :timecard_entries
  has_many :timecards, -> { distinct }, :through => :timecard_entries
  
  Member_Shirt_Sizes = ["XS", "S", "M", "L", "XL", "2XL", "3XL"]
  
  attr_accessor :login
  #attr_accessible :login, :password, :password_confirmation, :email, :namefirst, :namelast, :namenick, :title, :callsign, :shirt_size, :phone, :aim, :ssn, :payrate, :role_ids, :remember_me

  validates_presence_of     :namefirst, :namelast, :payrate
  validates_inclusion_of    :shirt_size, :in => Member_Shirt_Sizes
  validates :ssn, :format => { :with => /\A\d{4}\z/, :message => "must be exactly four digits", :allow_nil => true }

  validates_format_of :phone, :with => /\A\+?[0-9]*\Z/, :message => "must only use numbers"
  
  before_validation do |m|
    m.phone = m.phone.gsub(/[\.\- ]/, "") if m.phone
    m.callsign.upcase! if m.callsign.respond_to? "upcase!"
    m.ssn = nil if m.ssn.blank?
  end
  
  extend Enumerize
  enumerize :role, in: [:suspended, :alumni, :general_member, :exec, :membership_management, :tracker_dev], predicates: true
  validates_presence_of :role
  
  def active?
    not suspended? and not alumni?
  end
  
  scope :active, -> { where.not(role: ["suspended", "alumni"]) }
  
  def is_at_least?(pos)
    Member.role.values.index(self.role) >= Member.role.values.index(pos.to_s)
  end

  Default_sort_key = "namefirst"

  def fullname
    return namefirst + " " + namelast;
  end

  def to_s
    "#{fullname}"
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(email) = ? OR lower(email) = ?", login.downcase, login.downcase + "@andrew.cmu.edu"]).first
    else
      where(conditions).first
    end
  end
  
  def active_for_authentication?
    super and not suspended?
  end
end

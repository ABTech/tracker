class Member < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :encryptable, :encryptor => :restful_authentication_sha1, :authentication_keys => [:login]
  
  has_many :event_roles
  has_many :comments
  has_many :timecard_entries
  has_many :timecards, -> { distinct }, :through => :timecard_entries
  has_many :super_tics, -> { order(day: :asc) }, dependent: :destroy
  
  accepts_nested_attributes_for :super_tics, :allow_destroy => true
  
  attr_accessor :login

  validates_presence_of     :namefirst, :namelast, :payrate
  validates :ssn, :format => { :with => /\A\d{4}\z/, :message => "must be exactly four digits", :allow_nil => true }

  validates_format_of :phone, :with => /\A\+?[0-9]*\Z/, :message => "must only use numbers"
  
  before_validation do |m|
    m.phone = m.phone.gsub(/[\.\- ]/, "") if m.phone
    m.callsign.upcase! if m.callsign.respond_to? "upcase!"
    m.ssn = nil if m.ssn.blank?
    
    unless is_at_least? :exec
      m.super_tics.clear
    end
  end
  
  extend Enumerize
  enumerize :shirt_size, in: ["XS", "S", "M", "L", "XL", "2XL", "3XL"]
  enumerize :role, in: [:suspended, :alumni, :general_member, :exec, :tracker_management, :head_of_tech], predicates: true
  enumerize :key_possession, in: [:none, :bottom, :top]
  validates_presence_of :role
  
  scope :can_be_supertic, -> { where(role: [:exec, :tracker_management, :head_of_tech]).order(namefirst: :asc, namelast: :asc) }
  
  def active?
    not suspended? and not alumni?
  end
  
  scope :active, -> { where.not(role: ["suspended", "alumni"]) }
  scope :alphabetical, -> { order(namelast: :asc, namefirst: :asc) }
  scope :with_role, ->(role) { where(role: role) }
  
  def is_at_least?(pos)
    Member.role.values.index(self.role) >= Member.role.values.index(pos.to_s)
  end

  Default_sort_key = "namelast"

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
  
  def ability
    @ability ||= Ability.new(self)
  end
end

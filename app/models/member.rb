require 'digest/sha1'
class Member < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :encryptable, :encryptor => :restful_authentication_sha1, :authentication_keys => [:login]
  
  has_many :event_roles
  has_many :comments
  has_and_belongs_to_many :roles
  has_many :timecard_entries
  has_many :timecards, -> { distinct }, :through => :timecard_entries
  
  Member_Shirt_Sizes = ["XS", "S", "M", "L", "XL", "2XL", "3XL"]
  
  attr_accessor :login
  attr_accessible :login, :password, :password_confirmation, :email, :namefirst, :namelast, :namenick, :title, :callsign, :shirt_size, :phone, :aim, :ssn, :payrate, :role_ids, :remember_me

  validates_presence_of     :namefirst, :namelast, :payrate
  validates_inclusion_of    :shirt_size, :in => Member_Shirt_Sizes
  validates :ssn, :format => { :with => /\A\d{4}\z/, :message => "must be exactly four digits", :allow_nil => true }

  validates_format_of :phone, :with => /\A\+?[0-9]*\Z/, :message => "must only use numbers"
  before_validation Proc.new { |m|
    m.phone = m.phone.gsub(/[\.\- ]/, "") if m.phone
  }

  before_validation Proc.new { |m|
    m.callsign.upcase! if m.callsign.respond_to? "upcase!"
  }
  
  before_validation do |m|
    m.ssn = nil if not m.ssn.nil? and m.ssn.empty?
  end

  Default_sort_key = "namefirst"

  def fullname
    return namefirst + " " + namelast;
  end

  def to_s
    "#{fullname}"
  end

  def self.active
    Role.active.members
  end

  # Return true/false if User is authorized for resource.
  def authorized?(resource)
    if resource.respond_to? "each" and !resource.is_a? String
      return resource.collect{ |r| authorized?(r)}.inject { |sum, e| sum ||= e }
    end
      
    permission_strings.each do |p|
      r = Regexp.new(p)

      if((r =~ resource) != nil)
        return true;
      end
    end

    return false;
  end

  # Load permission strings 
  def permission_strings
    a = []
    self.roles.each{|r| r.permissions.each{|p| a<< p.pattern }}
    a
  end
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(email) = ? OR lower(email) = ?", login.downcase, login.downcase + "@andrew.cmu.edu"]).first
    else
      where(conditions).first
    end
  end
end

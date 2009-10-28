# == Schema Information
# Schema version: 78
#
# Table name: members
#
#  id                        :integer(11)     not null, primary key
#  namefirst                 :string(255)     default(""), not null
#  namelast                  :string(255)     default(""), not null
#  kerbid                    :string(255)     default(""), not null
#  namenick                  :string(255)     default(""), not null
#  title                     :string(255)
#  phone                     :string(255)     default(""), not null
#  aim                       :string(255)     default(""), not null
#  crypted_password          :string(40)      default(""), not null
#  salt                      :string(40)      default(""), not null
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)     default(""), not null
#  remember_token_expires_at :datetime
#  settingstring             :string(255)
#  callsign                  :string(255)
#  shirt_size                :string(20)
#

require 'digest/sha1'
class Member < ActiveRecord::Base
  
  has_many :eventroles;
  has_and_belongs_to_many :roles
  has_many :filters, :class_name => "MemberFilter", :order => "name ASC"

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :namefirst, :namelast, :kerbid;
  validates_associated      :filters;
  #Event::EmailRegex is a generic regex that matches email addresses. It is located in Event for absolutely no fucking reason.
  validates_format_of       :kerbid, :with => Event::EmailRegex;
  validates_uniqueness_of   :kerbid, :case_sensitive => false

  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?

  validates_format_of :phone, :with => /\A\+?[0-9]*\Z/, :message => "must only use numbers"
  before_validation Proc.new { |m|
    m.phone = m.phone.gsub(/[\.\- ]/, "") if m.phone
  }

  before_validation Proc.new { |m|
    m.callsign.upcase! if m.callsign.respond_to? "upcase!"
  }

  before_save :encrypt_password

  Default_sort_key = "namefirst"

  def fullname
    return namefirst + " " + namelast;
  end

  def to_s
    "#{fullname}"
  end

  def settings
    sets = {};
    if(settingstring)
        settingstring.split(",").each do |key|
            cur = key.split("=");
            sets.store(cur.first, cur.last);
        end
    end

    sets
  end

  def settings=(hash)
    update_attribute("settingstring", settings.update(hash).to_a().collect{|k| k.join("=")}.join(","));
  end

  def setting(key, default = nil)
    if(!settingstring)
        return default;
    end
    settingstring.split(",").each do |item|
        cur = item.split("=");
        if(key == cur.first)
            return cur.last;
        end
    end

    return default;
  end

  def self.authenticate(login, password)
    default_realm = "@andrew.cmu.edu"
    u = find_by_kerbid(login);
    #try adding the default realm to see if user was lazy (sam instead of sam@abtech.org)
    u = u || u = find_by_kerbid(login+default_realm) if login
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{kerbid}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
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

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{kerbid}--") if salt.blank?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end

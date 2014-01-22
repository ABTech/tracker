namespace :member do
  desc "Create a new member interactively."
  task(:new => :environment) do
    puts "This script will add a new user to the ABTech tracker in the #{ENV["RAILS_ENV"]} environment."
    puts "Please give the following information about the new user."
    m = Member.new
    begin
      if m.email.nil? or m.email.empty? or m.errors.on(:email)
        puts "email "+m.errors[:email].to_a.join(" & ") if m.errors[:email]
        print "email: "
        m.email = STDIN.gets
      end
      if m.password.nil? or m.errors.on(:password) or m.errors.on(:password_confirmation)
        puts "Password "+m.errors[:password].to_a.join(" & ") if m.errors[:password]
        puts "Password confirmation "+m.errors[:password_confirmation] if m.errors[:password_confirmation]
        print "Password: "
        system "stty -echo"
        m.password = STDIN.gets
        puts
        print "Confirm password: "
        m.password_confirmation = STDIN.gets
        puts
        system "stty echo"
      end
      if m.namefirst.nil? or m.namefirst.empty? or m.errors.on(:namefirst)
        puts "First name "+m.errors.on(:namefirst).to_a.join(" & ") if m.errors[:namefirst]
        print "First name: "
        m.namefirst = STDIN.gets
      end
      if m.namelast.nil? or m.namelast.empty? or m.errors.on(:namelast)
        puts "Last name "+m.errors[:namelast].to_a.join(" & ") if m.errors[:namelast]
        print "Last name: "
        m.namelast = STDIN.gets
      end
      if m.namenick.nil? or m.namenick.empty? or m.errors.on(:namenick)
        puts "Nick name "+m.errors[:namenick].to_a.join("  &  ") if m.errors[:namenick]
        print "Nick name: "
        m.namenick = STDIN.gets
      end
      if m.phone.nil? or m.phone.empty? or m.errors.on(:phone)
        puts "Phone number "+m.errors[:phone].to_a.join(" & ") if m.errors[:phone]
        print "Phone number: "
        m.phone = STDIN.gets
      end
      if m.aim.nil? or m.aim.empty? or m.errors.on(:aim)
        puts "Aim "+m.errors[:aim].to_a.join(" & ") if m.errors[:aim]
        print "Aim: "
        m.aim = STDIN.gets
      end
      m.save
      if m.errors.size > 0
        puts "It seems there are #{m.errors.size} error(s) saving the new user. Please fix each of the following issues: "
      end
    end while m.new_record?
      puts "Thanks you're done. You can now log in at http://abtt.abtech.org/"
  end
end

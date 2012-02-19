module BugsHelper
  def summarize(text)
    #this helper method sucks
    return "" if text.nil?
    return text if text.length < 205
    text.gsub!("\n\n", "<br />")
    return word_wrap(text[0, 100]+"..."+text[-100, 100]).gsub("\n", "<br />") 
  end

  def class_for(bug)
    #TODO:
    #raise unless bug.respond_to? priority and bug.respond_to? confirmed? and bug.respond_to resolved? and bug.respond_to? closed?
    return "bug"
  end

  def yes
    return 'yes'
  end

  def no
    return 'no'
  end
end

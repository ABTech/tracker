class TshirtsController < ApplicationController
  layout "application2"

  def index
    @title = "T-Shirt Sizes"

    @shirt_sizes = Hash.new
    
    Member.active.each do |m|
      if m.shirt_size.nil? or m.shirt_size.empty?
        size = "Unknown"
      else
        size = m.shirt_size.strip
      end

      @shirt_sizes[size] ||= Array.new
      @shirt_sizes[size] << m
    end
  end
end

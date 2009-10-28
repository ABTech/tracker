class MemberFilterController < ApplicationController
    before_filter :login_required;

    def edit
        @filter = MemberFilter.find_by_id(@params["id"]);

        if(!@filter)
            flash[:error] = "Please select a valid filter to edit.";
        elsif(@filter.member != current_member())
            flash[:error] = "You cannot edit someone else's filter.";
        end

        render(:action => "member_filter/edit", :layout => false);
    end

    def save 
        filter = MemberFilter.find(@params["id"]);

        if(!filter)
            flash[:error] = "Please select a valid filter to edit.";
        elsif(filter.member != current_member())
            flash[:error] = "You cannot edit someone else's filter.";
        else
            if(filter.update_attributes(@params["filter"]))
                flash[:notice] = "Filter updated.";
            else
                flash[:error] = "";
                filter.errors.each_full do |msg|
                    flash[:error] << msg << "<br/>";
                end
            end
        end

        render(:action => "member_filter/save", :layout => false);
    end

    def new
        newfilt = MemberFilter.new({:member => current_member()});
        newfilt.save();
    end
end

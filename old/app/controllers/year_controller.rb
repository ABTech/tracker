class YearController < ApplicationController
    def change_year
        newone = Year.find(params[:year]);
        if(newone)
            current_member.settings = {"active_year" => newone.id};
        end

        redirect_to :back;
    end
end

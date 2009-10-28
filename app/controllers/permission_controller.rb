class PermissionController < ApplicationController
    before_filter :login_required;
    scaffold :permission;
end

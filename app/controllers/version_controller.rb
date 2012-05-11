class VersionController < ApplicationController
  layout false

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end
end

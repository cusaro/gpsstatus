class GpsfileController < ApplicationController

  def index
    @files = GpsFile.all().order(start: :desc);
  end

  def show
    @file = GpsFile.find(params[:id])

  end

end

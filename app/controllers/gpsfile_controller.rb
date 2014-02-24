class GpsfileController < ApplicationController

  def index
    @files = GpsFile.all().page(params[:page]).per(2).order(start: :desc);
  end

  def show
    @file = GpsFile.find(params[:id])
  end

end

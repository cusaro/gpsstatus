class GpsfileController < ApplicationController

  def index
    @filter = filter
    @tags = Tag.all()

    @files = GpsFile.all().tag(@filter).page(params[:page]).per(10).order(start: :desc);
  end

  def show
    @file = GpsFile.find(params[:id])
  end

  def filter
    if params["post"].present?
      params["post"]["tag_id"]
    else
      false
    end
  end

end

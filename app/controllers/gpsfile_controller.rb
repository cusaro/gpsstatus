class GpsfileController < ApplicationController

  def index
    @filter = filter
    @tags = Tag.all().order(:name)

    @files = GpsFile.all().tag(@filter).page(params[:page]).per(10).order(start: :desc)
  end

  def show
    @file = GpsFile.find(params[:id])
  end

  def tag_add
    gpx = GpsFile.find params["id"]
    @tag = gpx.tag_add(params["tag"])
  end

  def tag_remove
    @tag = params["tag"]
    gpx = GpsFile.find params["id"]
    gpx.tag_remove(@tag)
  end

  def filter
    if params["post"].present?
      params["post"]["tag_id"]
    else
      false
    end
  end

end

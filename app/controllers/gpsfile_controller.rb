class GpsfileController < ApplicationController

  def index
    @this_week = GpsFile.statistics(Time.now.beginning_of_week..Time.now.end_of_week)
    @this_month = GpsFile.statistics(Time.now.beginning_of_month..Time.now.end_of_month)
    @this_year = GpsFile.statistics(Time.now.beginning_of_year..Time.now.end_of_year)

    @last_week = GpsFile.statistics(Time.now.ago(1.week).beginning_of_week..Time.now.ago(1.week).end_of_week)
    @last_month = GpsFile.statistics(Time.now.ago(1.month).beginning_of_month..Time.now.ago(1.month).end_of_month)
    @last_year = GpsFile.statistics(Time.now.ago(1.year).beginning_of_year..Time.now.ago(1.year).end_of_year)

    #@total = GpsFile.addition(GpsFile.all)

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

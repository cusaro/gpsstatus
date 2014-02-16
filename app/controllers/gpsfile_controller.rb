class GpsfileController < ApplicationController

  def index
    @files = GpsFile.all();
  end

end

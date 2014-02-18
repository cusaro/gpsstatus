require 'gpx'
require 'gpx2png'
require 'geocoder'
class ImporterController < ApplicationController
  IMPORT_DIR = 'public/system/gpxfiles/import/'
  GPX_DIR = IMPORT_DIR
  THUMBNAIL_DIR = 'app/assets/images/thumbnails'

  def import
    filelist.each do |file|
      next if GpsFile.exists?(filename: File.basename(file))
      @file = file

      gpx = GPX::GPX.new File.join(file)
      location = geocode(gpx)
      image = File.open(create_image)

      GpsFile.create(
          name: File.basename(file),
          duration: gpx.duration,
          length: gpx.length,
          average_speed: gpx.average_speed,
          start: gpx.start_date,
          end: gpx.end_date,
          image: image,
          country: location[:country],
          city: location[:city],
          filename: File.basename(file),
      )

      image.close
    end
  end

  def filelist
    Dir[IMPORT_DIR+"*.gpx"].reject{ |f| f[%r{.*_[0-9][0-9][0-9].gpx}]  }
  end

  def geocode(gpx)

    if gpx.points.first.nil?
      {city: nil,country: nil}
    else
      location = Geocoder.search([gpx.points.first.latitude,gpx.points.first.longitude])

      {
          city: location[0].data["address_components"][3]["long_name"],
          #country: location[0].data["address_components"][6]["long_name"],
          country: 'none',
      }
    end



  end

  def imagename
    File.basename(@file, '.gpx')+'.jpg'
  end

  def image_path
    File.join(THUMBNAIL_DIR,imagename)
  end

  def create_image
    g = GpxUtils::TrackImporter.new
    g.add_file @file

    e = Gpx2png::Osm.new
    e.coords = g.coords
    e.renderer = :rmagick
    e.renderer_options = { aa: true, color: '#0000FF', opacity: 0.5, crop_enabled: true }
    e.zoom = 19
    e.fixed_size(800, 800)
    e.save(image_path)
    image_path
  end

end

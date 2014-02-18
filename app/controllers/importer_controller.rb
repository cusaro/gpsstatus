require 'gpx'
require 'gpx2png'
require 'geocoder'
class ImporterController < ApplicationController
  IMPORT_DIR = 'public/system/gpxfiles/import/'
  GPX_DIR = IMPORT_DIR
  THUMBNAIL_DIR = 'app/assets/images/thumbnails'

  def import
    filelist.each do |file|
      @file = file

      next if file_exists?

      gpx = GPX::GPX.new file
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

    return {city: nil,country: nil} if gpx.points.first.nil?

    location = Geocoder.search([gpx.points.first.latitude,gpx.points.first.longitude])[0].data["address_components"]
    city = location.select { |e| e['types'][0] == "locality"}
    country = location.select { |e| e['types'][0] == "country"}

    {
        city: city[0]["long_name"] ,
        country: country[0]["long_name"],
    }

  end

  def imagename
    File.basename(@file, '.gpx')+'.jpg'
  end

  def image_path
    File.join(THUMBNAIL_DIR,imagename)
  end

  def file_exists?
    GpsFile.exists?(filename: File.basename(@file))
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

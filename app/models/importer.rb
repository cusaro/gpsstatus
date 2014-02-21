require 'gpx'

class Importer
  IMPORT_DIR = 'public/system/gpxfiles/import/'
  GPX_DIR = IMPORT_DIR
  THUMBNAIL_DIR = 'app/assets/images/thumbnails'

  def import
    filelist.each do |file|

      next if file_exists?(file)

      gpx = GPX::GPX.new file

      GpsFile.create(
          name: File.basename(file),
          duration: gpx.duration,
          length: gpx.length,
          average_speed: gpx.average_speed,
          start: gpx.start_date,
          end: gpx.end_date,
          image: File.open(image(file)),
          country: geocode(gpx).country,
          city: geocode(gpx).city,
          filename: File.basename(file),
      )

    end
  end

  def filelist
    Dir[IMPORT_DIR+"*.gpx"].reject{ |f| f[%r{.*_[0-9][0-9][0-9].gpx}]  }
  end

  def file_exists?(file)
    GpsFile.exists?(filename: File.basename(file))
  end

  def geocode(gpx)
    Geocode.new(gpx)
  end

  def image(file)
    i = Image.new(file)
    i.create_image
  end

end


#rails runner -e prodction "Importer.import"
#rake import
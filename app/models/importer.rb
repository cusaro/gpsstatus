require 'gpx'

class Importer
  IMPORT_DIR = 'public/system/gpxfiles/import/'
  GPX_DIR = IMPORT_DIR
  THUMBNAIL_DIR = 'app/assets/images/thumbnails'

  def import
    filelist.each do |file|
      @file = file

      next if file_exists?

      gpx = GPX::GPX.new file
      image = File.open(create_image)

      GpsFile.create(
          name: File.basename(file),
          duration: gpx.duration,
          length: gpx.length,
          average_speed: gpx.average_speed,
          start: gpx.start_date,
          end: gpx.end_date,
          image: image,
          country: geocode(gpx).country,
          city: geocode(gpx).city,
          filename: File.basename(file),
      )

      image.close
    end
  end

  def filelist
    Dir[IMPORT_DIR+"*.gpx"].reject{ |f| f[%r{.*_[0-9][0-9][0-9].gpx}]  }
  end

  end

  def imagename
    File.basename(@file, '.gpx')+'.jpg'
  def geocode(gpx)
    Geocode.new(gpx)
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


#rails runner -e prodction "Importer.import"
#rake import
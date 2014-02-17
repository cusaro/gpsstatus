require 'gpx'
require 'gpx2png'
require 'geocoder'
class ImporterController < ApplicationController
  include Paperclip::Glue

  IMPORT_DIR = 'public/gpxfiles/import/'
  THUMBNAIL_DIR = 'app/assets/images/thumbnails'

  def index
    filelist.each {|file| import(file)}
  end

  def import(file)
    @file = file
    @location = nil
    @filename = nil

    gpx = GPX::GPX.new File.join(file)

    createimage
    image = File.open(imagedir)

    file = GpsFile.create(
        name: File.basename(file),
        duration: gpx.duration,
        length: gpx.length,
        average_speed: gpx.average_speed,
        start: gpx.start_date,
        end: gpx.end_date,
        image: image,
        country: location(gpx)[:country],
        city: location(gpx)[:city],
        filename: File.basename(file),
    )

    image.close

  end

  def filelist
    Dir[IMPORT_DIR+"*"]
  end

  def location(gpx)
    if @location != nil
      @location
    else
      location = Geocoder.search([gpx.points.first.latitude,gpx.points.first.longitude])

      @location = {
        city: location[0].data["address_components"][3]["long_name"],
        country: location[0].data["address_components"][6]["long_name"],
      }
    end
  end

  def imagedir
    File.join(THUMBNAIL_DIR,imagename)
  end

  def imagename
    if @filename != nil
      @filename
    else
      @filename = (0...8).map { (65 + rand(26)).chr }.join.downcase+'.jpg'
    end
  end

  def createimage
    g = GpxUtils::TrackImporter.new
    g.add_file @file

    e = Gpx2png::Osm.new
    e.coords = g.coords
    e.renderer = :rmagick
    e.renderer_options = { aa: true, color: '#0000FF', opacity: 0.5, crop_enabled: true }
    e.zoom = 19
    e.fixed_size(800, 800)
    e.save(imagedir)

  end

  def transliterate(str)

    # Escape str by transliterating to UTF-8 with Iconv
    s = str

    # Downcase string
    s.downcase!

    # Remove apostrophes so isn't changes to isnt
    s.gsub!(/'/, '')

    # Replace any non-letter or non-number character with a space
    s.gsub!(/[^A-Za-z0-9]+/, ' ')

    # Remove spaces from beginning and end of string
    s.strip!

    # Replace groups of spaces with single hyphen
    s.gsub!(/\ +/, '-')

    return s
  end

end

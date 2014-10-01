class Importer

  def self.import
    file.each do |file|
      f = new(file)
      f.save unless f.file_exists?
    end
  end

  def initialize(file)
    @file = file
  end

  def self.file
    Dir[IMPORT_DIR+"*.gpx"].reject{ |f| f[%r{.*_[0-9][0-9][0-9].gpx}]  }
  end

  def file_exists?
    GpsFile.exists?(filename: filename)
  end

  def save
    gpx = GpsFile.create(
        name: filename,
        duration: import_file.duration,
        length: import_file.length,
        average_speed: import_file.average_speed,
        start: import_file.start_date,
        end: import_file.end_date,
        image: File.open(image),
        filename: filename,
    )

    gpx.tag_add(geocode(import_file).city)
    gpx.tag_add(geocode(import_file).country)
  end

  def import_file
    @import_file ||= GPX::GPX.new @file
  end

  def filename
    File.basename(@file)
  end

  def geocode(gpx)
    @geocode ||= Geocode.new(gpx)
  end

  def image

    if @image.present?
      @image
    else
      #TODO Check if this could be done in one chain
      @image = Image.new(@file)
      @image.create_image
    end

  end

end

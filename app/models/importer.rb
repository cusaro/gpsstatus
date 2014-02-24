class Importer

  def save(file)
    gpx_file = GPX::GPX.new file

    gpx = GpsFile.create(
        name: File.basename(file),
        duration: gpx_file.duration,
        length: gpx_file.length,
        average_speed: gpx_file.average_speed,
        start: gpx_file.start_date,
        end: gpx_file.end_date,
        image: File.open(image(file)),
        filename: File.basename(file),
    )

    gpx.tags << Tag.find_or_create_by(name: geocode(gpx_file).city)
    gpx.tags << Tag.find_or_create_by(name: geocode(gpx_file).country)
  end

  def geocode(gpx)
    @geocode ||= Geocode.new(gpx)
  end

  def image(file)

    if @image.present?
      @image
    else
      @image = Image.new(file)
      @image.create_image
    end

  end

end
class Importer

  def save(file)
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
require 'gpx2png'
class Image

  def initialize(file)
    @file = file
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
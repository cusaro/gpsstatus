module GpsfileHelper
  def map_gpx(file)
    output = []
    output << '<script>'
    output << "var gpx = '#{file}'; // URL to your GPX file or the GPX itself"
    output << "new L.GPX(gpx, {async: true}).on('loaded', function(e) {"
    output <<   'map.fitBounds(e.target.getBounds());'
    output << '}).addTo(map);'
    output << '</script>'

    output.join("\n").html_safe
  end
end

require 'gpx'

Thread.new do
  listener = Listen.to('public/system/gpxfiles/import/') do |modified, added, removed|
    unless added.empty?
      added.each do |file|
        Importer.new(file).save
      end
    end
  end
  listener.start # not blocking
end
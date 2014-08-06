require 'gpx'

Thread.new do

  if Rails.env.production?
    path = '/var/webapps/gpsstats/shared/public/system/gpxfiles/import/'
  else
    path = 'public/system/gpxfiles/import/'
  end

  listener = Listen.to(path,wait_for_delay: 30 ) do |modified, added, removed|
    unless added.empty?
      added.each do |file|
        Importer.new(file).save
      end
    end
  end
  listener.start # not blocking
end
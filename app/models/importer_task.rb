require 'gpx'

class ImporterTask
  IMPORT_DIR = 'public/system/gpxfiles/import/'
  GPX_DIR = IMPORT_DIR
  THUMBNAIL_DIR = 'app/assets/images/thumbnails'

  def import
    filelist.each { |file| Importer.new().save(file) unless file_exists?(file) }
  end

  def filelist
    Dir[IMPORT_DIR+"*.gpx"].reject{ |f| f[%r{.*_[0-9][0-9][0-9].gpx}]  }
  end

  def file_exists?(file)
    GpsFile.exists?(filename: File.basename(file))
  end

end


#rails runner -e prodction "Importer.import"
#rake import
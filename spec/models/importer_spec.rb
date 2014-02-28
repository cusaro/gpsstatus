require 'spec_helper'
require 'vcr_setup'

describe Importer do

  let(:gpx1){ GPX::GPX.new 'public/system/gpxfiles/import/radtour-20100402.gpx' }
  let(:geocode_result_for_gps1){ {:city=>"Leipzig", :country=>"Germany"} }

  let(:gpx2){ GPX::GPX.new 'public/system/gpxfiles/import/2013-09-18_09-33-42.gpx' }
  let(:geocode_result_for_gps2){ {:city=>"Morter", :country=>"Italy"} }


  describe '.geocode' do
    it 'for radtour-  20100402.gpx' do
      VCR.use_cassette('geocode_for_radtour-20100402.gpx') do
        g = Geocode.new(gpx1)
        expect(g.city).to eq "Leipzig"
        expect(g.country).to eq "Germany"
      end
    end

    #it 'for 2013-09-18_09-33-42.gpx' do
    #  VCR.use_cassette('geocode_for_2013-09-18_09-33-42.gpx') do
    #    expect(Importer.new.geocode(gpx2)).to eq geocode_result_for_gps2
    #  end
    #end
  end


end

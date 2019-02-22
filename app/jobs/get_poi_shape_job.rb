class GetPOIShapeJob < ApplicationJob
  queue_as :default

  require 'underpass'

  def perform(poi_id)
    poi = POI.find(poi_id)
    poi.zones.with_expanded_bounding_box.each do |z|
      matches = Underpass::QL::Query.perform(
        z.expanded_bounding_box,
        poi.overpass_query
      )
      if matches.size
        poi.update_column(:shape, matches.first)
        break
      end
    end
    # if not found, send email
  end
end

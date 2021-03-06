module Rome2rio
  class Segment
    attr_reader :kind, :isMajor, :distance, :duration, :indicativePrice, :isImperial,
    :sName, :sPos, :sCode, :tName, :tPos, :tCode, :path, :itineraries
    def initialize(json)
      # Possible kinds: walk, car, train, bus, ferry, flight
      @kind = json["kind"]
      @isMajor = json["isMajor"]
      @distance = json["distance"]
      @duration = json["duration"]
      @indicativePrice = IndicativePrice.new(json["indicativePrice"])

      if @kind != "flight" then
        @isImperial = json["isImperial"]
        @sName = json["sName"]
        @sPos = Position.new_parse(json["sPos"])
        @tName = json["tName"]
        @tPos = Position.new_parse(json["tPos"])
        @path = json["path"]
      else
        @sCode = json["sCode"]
        @tCode = json["tCode"]
        @itineraries = []
        json["itineraries"].each { |itinerary| @itineraries << FlightItinerary.new(itinerary) }
      end

      if [ "train", "bus", "ferry" ].include?(@kind) then
        @itineraries = []
        json["itineraries"].each { |itinerary| @itineraries << TransitItinerary.new(itinerary) }
      end
    end
  end
end

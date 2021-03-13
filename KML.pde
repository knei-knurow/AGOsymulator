//zmienne do mapy Google Earth
XML kml;
XML Document;
XML styleUp;
XML styleDown;

float prevAltitude;
float prevLatitude;
float prevLongitude;

//do Google Earth
void KMLSetup()
{
    kml = new XML("kml");
    Document = kml.addChild("Document");
    
    styleUp = Document.addChild("Style");
    styleUp.setString("id", "up");
    XML LineStyle = styleUp.addChild("LineStyle");
    XML Color = LineStyle.addChild("color");
    Color.setContent("ff00ff00");
    XML PolyStyle = styleUp.addChild("PolyStyle");
    Color = PolyStyle.addChild("color");
    Color.setContent("ff00ff00");
    
    styleDown = Document.addChild("Style");
    styleDown.setString("id", "down");
    LineStyle = styleDown.addChild("LineStyle");
    Color = LineStyle.addChild("color");
    Color.setContent("ff0000ff");
    PolyStyle = styleDown.addChild("PolyStyle");
    Color = PolyStyle.addChild("color");
    Color.setContent("ff0000ff");
}

void addCoordinates(float dLongitude, float dLatitude, float dAltitude)
{
    if(prevAltitude == 0)  prevAltitude = dAltitude;
    if(prevLongitude == 0)  prevLongitude = dLongitude;
    if(prevLatitude == 0)  prevLatitude = dLatitude;
   
    XML Placemark = Document.addChild("Placemark");
    XML styleUrl = Placemark.addChild("styleUrl");
    if(dAltitude > prevAltitude)  
    {
        styleUrl.setContent("#up");
    }
    else
    {
        styleUrl.setContent("#down"); 
    }
    XML LineString = Placemark.addChild("LineString");
    XML extrude = LineString.addChild("extrude");
    extrude.setContent("1");
    XML altitudeMode = LineString.addChild("altitudeMode");
    altitudeMode.setContent("absolute");
    XML coordinates = LineString.addChild("coordinates");
    coordinates.setContent(prevLatitude + "," + prevLongitude + ","+ prevAltitude + "   " + dLatitude + "," + dLongitude + "," + dAltitude);
   
    prevLongitude = dLongitude;
    prevLatitude = dLatitude;
    prevAltitude = dAltitude;
 
    saveXML(kml, "data.kml");
}

void restartKML()
{
    prevAltitude = 0;
    prevLongitude = 0;
    prevLatitude = 0;
    KMLSetup();
}

class Location {
  String protocol = '';
  String hostname = '';
  String port = '';
  String href = '';
  String origin = '';
  String host = '';
  String pathname = '';
  String search = '';
  String hash = '';
}

class Window {
  Location location = Location();
}

Window window = Window();

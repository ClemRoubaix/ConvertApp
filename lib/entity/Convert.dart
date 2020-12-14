class Convert {
  //Variables
  int timeStamp;
  double value;
  // Constructor
  Convert({this.value, this.timeStamp});
  // Factory
  factory Convert.fromJson(Map<String, dynamic> json) {
    return Convert(
        value: json["vl"],
        timeStamp: json["ts"]
    );
  }
}
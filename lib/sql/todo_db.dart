class TODO {
  int? id;
  final String contents, type;
  final int day, month, year, timeMill, random;
  final int isCompleted;
  TODO({
    this.id,
    required this.contents,
    required this.day,
    required this.month,
    required this.timeMill,
    required this.type,
    required this.year,
    required this.isCompleted,
    required this.random,
  });
  factory TODO.fromMap(Map<String, dynamic> json) => TODO(
      id: json['id'],
      contents: json['contents'],
      day: json['day'],
      month: json['month'],
      timeMill: json['timeMill'],
      type: json['type'],
      random: json['random'],
      isCompleted: json['isCompleted'],
      year: json['year']);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contents': contents,
      'day': day,
      'month': month,
      'timeMill': timeMill,
      'type': type,
      'year': year,
      'random': random,
      'isCompleted': isCompleted,
    };
  }
}

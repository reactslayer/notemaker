class Note {
  final int? id;
  final String title;
  final String description;
  Note({this.id, required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'note{title: $title, description: $description}';
  }
}

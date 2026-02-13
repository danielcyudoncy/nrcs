// core/models/story.dart
class Story {
  final String id;
  final String slug;
  final int orderNo;
  final String status;
  final String script;
  final int version;
  final String? assignedTo;
  final String? notes;
  final double prompterSpeed; // 1.0 is default
  final String? updatedBy;

  Story({
    required this.id,
    required this.slug,
    required this.orderNo,
    required this.status,
    this.script = '',
    this.version = 1,
    this.updatedBy,
    this.assignedTo,
    this.notes,
    this.prompterSpeed = 1.0,
  });

  factory Story.fromMap(Map<String, dynamic> m) => Story(
    id: m['id'] as String,
    slug: m['slug'] as String,
    orderNo: m['orderNo'] as int,
    status: m['status'] as String,
    script: (m['script'] ?? '') as String,
    version: (m['version'] ?? 1) as int,
    updatedBy: m['updatedBy'] as String?,
    assignedTo: m['assignedTo'] as String?,
    notes: m['notes'] as String?,
    prompterSpeed: (m['prompterSpeed'] ?? 1.0) as double,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'slug': slug,
    'orderNo': orderNo,
    'status': status,
    'script': script,
    'version': version,
    'updatedBy': updatedBy,
    'assignedTo': assignedTo,
    'notes': notes,
    'prompterSpeed': prompterSpeed,
  };

  Story copyWith({
    String? slug,
    int? orderNo,
    String? status,
    String? script,
    int? version,
    String? updatedBy,
    String? assignedTo,
    String? notes,
    double? prompterSpeed,
  }) => Story(
    id: id,
    slug: slug ?? this.slug,
    orderNo: orderNo ?? this.orderNo,
    status: status ?? this.status,
    script: script ?? this.script,
    version: version ?? this.version,
    updatedBy: updatedBy ?? this.updatedBy,
    assignedTo: assignedTo ?? this.assignedTo,
    notes: notes ?? this.notes,
    prompterSpeed: prompterSpeed ?? this.prompterSpeed,
  );
}

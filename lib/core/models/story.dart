// core/models/story.dart
class Story {
  final String id;
  final String slug;
  final int orderNo;
  final String status;
  final String script;
  final int version;
  final String? updatedBy;

  Story({required this.id, required this.slug, required this.orderNo, required this.status, this.script = '', this.version = 1, this.updatedBy});

  factory Story.fromMap(Map<String, dynamic> m) => Story(
    id: m['id'] as String,
    slug: m['slug'] as String,
    orderNo: m['orderNo'] as int,
    status: m['status'] as String,
    script: (m['script'] ?? '') as String,
    version: (m['version'] ?? 1) as int,
    updatedBy: m['updatedBy'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'slug': slug,
    'orderNo': orderNo,
    'status': status,
  'script': script,
  'version': version,
  'updatedBy': updatedBy,
  };

  Story copyWith({String? slug, int? orderNo, String? status}) => Story(
    id: id,
    slug: slug ?? this.slug,
    orderNo: orderNo ?? this.orderNo,
    status: status ?? this.status,
    script: script,
    version: version,
    updatedBy: updatedBy,
  );
}

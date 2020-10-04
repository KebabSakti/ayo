class Viewer {
  Viewer({
    this.id,
    this.viewerId,
    this.relationId,
    this.userId,
    this.view,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String viewerId;
  final String relationId;
  final String userId;
  final int view;
  final DateTime createdAt;
  final DateTime updatedAt;

  Viewer copyWith({
    int id,
    String viewerId,
    String relationId,
    String userId,
    int view,
    DateTime createdAt,
    DateTime updatedAt,
  }) =>
      Viewer(
        id: id ?? this.id,
        viewerId: viewerId ?? this.viewerId,
        relationId: relationId ?? this.relationId,
        userId: userId ?? this.userId,
        view: view ?? this.view,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

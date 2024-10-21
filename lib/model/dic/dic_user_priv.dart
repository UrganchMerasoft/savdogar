class DicUserPriv {
  late int id;
  late int userId;
  late int privId;
  late bool canWork;
  late bool canAdd;
  late bool canEdit;
  late bool canDelete;

  DicUserPriv({
    required this.id,
    required this.userId,
    required this.privId,
    required this.canWork,
    required this.canAdd,
    required this.canEdit,
    required this.canDelete,
  });

  factory DicUserPriv.fromJson(Map<String, dynamic> json) {
    return DicUserPriv(
      id: json['id'],
      userId: json['user_id'],
      privId: json['priv_id'],
      canWork: json['can_work'],
      canAdd: json['can_add'],
      canEdit: json['can_edit'],
      canDelete: json['can_delete'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "priv_id": privId,
        "can_work": canWork,
        "can_add": canAdd,
        "can_edit": canEdit,
        "can_delete": canDelete,
      };

  DicUserPriv.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    userId = map['user_id'] ?? "?";
    privId = map['priv_id'] ?? "";
    canWork = map['can_work'] ?? "";
    canAdd = map['can_add'] ?? "";
    canEdit = map['can_edit'] ?? "";
    canDelete = map['can_delete'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['priv_id'] = privId;
    map['can_work'] = canWork;
    map['can_add'] = canAdd;
    map['can_edit'] = canEdit;
    map['can_delete'] = canDelete;

    return map;
  }
}

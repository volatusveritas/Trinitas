class_name Hitboxes

static func rectangle(item: TableItem, point: Vector2) -> bool:
    return Rect2(Vector2.ZERO, item.size).has_point(point)

# TODO: make this work with "stretched circles"
static func ellipse(item: TableItem, point: Vector2) -> bool:
    return point.distance_to(item.size / 2) <= item.size.x / 2

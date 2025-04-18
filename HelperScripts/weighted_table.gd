class_name WeightedTable
extends Object


static func pick_item_from_weighted_table(items_and_weights: Array[Weighted]) -> Weighted:
	var total_weight: float = 0
	for item: Weighted in items_and_weights:
		total_weight += item.weight
	
	if total_weight == 0:
		push_error("Total weight is 0 in pick_item_from_weighted_table")
		return null

	var chosen: float = randf_range(0.0, total_weight)
	var accumulated_weight: float = 0.0
	
	for item in items_and_weights:
		accumulated_weight += item.weight
		if chosen < accumulated_weight:
			return item
	
	# Fallback return (should never happen)
	push_error("No item selected in weighted table. Check weights.")
	return items_and_weights.back() if items_and_weights.size() > 0 else null

tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("SegmentedProgress", "Control", preload("segmented_progress.gd"), preload("SegmentedProgress.svg"))


func _exit_tree():
	remove_custom_type("SegmentedProgress")

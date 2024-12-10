class Utils {

  
  /// Removes all children from the given parent widget.
  static void removeAllChildren(dynamic parent) {
    if (parent != null && parent.children != null) {
      parent.children.toList().forEach((child) {
        child.removeFromParent();
      });
    }
  }
}
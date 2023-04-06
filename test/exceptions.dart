import 'package:flutter_test/flutter_test.dart';

Matcher sameDraggedItemAndTargetAreaException() {
  return throwsA(predicate((x) =>
      x is ArgumentError &&
      x.message ==
          "Argument draggedItem cannot be the same as argument targetArea. A DockingItem cannot be rearranged on itself."));
}

Matcher dockingAreaInSomeLayoutException() {
  return throwsA(predicate((x) =>
      x is ArgumentError &&
      x.message == "DockingArea already belongs to some layout."));
}

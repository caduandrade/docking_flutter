## 1.16.1

* Bugfix
  * The `removeItemById` method does not preserving id.

## 1.16.0

* `Docking`
  * Allow to disable draggable

## 1.15.0

* `DockingLayout`
  * Method `findDockingTabsWithItem` to finds a `DockingTabs` that has a `DockingItem` with the given id.
* Theme
  * The `DockingTheme` class has been added to provide icons customization.

## 1.14.1

* Bugfix
  * Fixing the issue that reset the weight after using the `DockingLayout.addItemOn` method.

## 1.14.0

* The `id` attribute has been moved from the `DockingItem` to the `DockingArea`.
* `DockingLayout`
  * The `findDockingArea` method has been added to locate any area given an id. 
  * Save/Load layout feature.
    * The `stringify` and `load` methods have been added to convert the layout to String and to load a layout given a String.

## 1.13.0

* Allow `DockingTabs` to be initialized with only 1 child.

## 1.12.0

* `tabbed_view` dependency updated to 1.18.0
  * Tab reordering
* `DropPosition`
  * The `center` value has been removed.
* `DockingLayout`
  * Methods `addItemOnRoot`, `addItemOn` and `moveItem`
    * New optional parameter: `dropIndex`
    * The `dropPostion` parameter has become optional.

## 1.11.2

* Bugfix
  * Error with GlobalKey when expanding a DockingTabs.

## 1.11.1

* Bugfix
  * Newer tabbed_view dependency being used causing incompatibility.

## 1.11.0

* `DockingLayout`
  * New method: `removeItemByIds`
* Bugfix
  * `Docking` is not updating itself after being instantiated with new `DockingLayout`

## 1.10.0

* `DockingItem`
  * Allow changing attributes.
  * The `clone` method has been removed.
* `DockingLayout`
  * New method: `findDockingItem`.

## 1.9.0

* `DockingRow`, `DockingColumn` and `DockingTabs`
  * New optional constructor parameters: `size`, `weight`, `minimalWeight` and `minimalSize` 

## 1.8.0

* `DockingArea`
  * Allowing to configure the initial and minimum size and weight.

## 1.7.0

* `multi_split_view` dependency updated to 2.3.1
* `Docking`
  * New parameter: `antiAliasingWorkaround`.
* Bugfix
  * The anti-aliasing workaround is clipping a pixel.

## 1.6.0

* `multi_split_view` dependency updated to 2.2.0
* `tabbed_view` dependency updated to 1.16.0
* Exporting dependencies `tabbed_view` and `multi_split_view` along with this package.
* Item leading widget.

## 1.5.0

* `tabbed_view` dependency updated to 1.15.0

## 1.4.1+1

* `tabbed_view` dependency updated to 1.14.0+1

## 1.4.1

* Bugfix
  * Maximizing DockingItem disposes DockingItem's where keepAlive is set true.
* `tabbed_view` dependency updated to 1.14.0

## 1.4.0

* New `Docking` parameter: `maximizableTabsArea`
* `Docking.maximizableTabs` parameter has been renamed to `Docking.maximizableTab` 
* Bugfix
  * Non maximizable `DockingItem` can be maximized.
  
## 1.3.0

* Allow changing DockingLayout root.
* Bugfix
  * Memory leak in DockingLayout listeners.    
* `tabbed_view` dependency updated to 1.13.0+1
* `multi_split_view` dependency updated to 2.1.0

## 1.2.0+1

* Updating the README

## 1.2.0

* `multi_split_view` dependency updated to 1.11.0

## 1.1.0

* `multi_split_view` dependency updated to 1.9.0

## 1.0.0

* Feature to maximize docking areas

## 0.6.1

* `multi_split_view` dependency updated to 1.7.2

## 0.6.0

* Feature to keep the state alive
* `DockingButtonsBuilder` typedef

## 0.5.0

* Dynamic value in `DockingItem`
* Non-Closable `DockingItem`
* `DockingItem`
  * selection listener
  * close listener
  * close interceptor
  * buttons

## 0.4.0

* Method to add item
* Keep the row and column children's weight, and the selected tab's index after rearranging the layout

## 0.3.0

* Method to remove item

## 0.2.0

* Drag and Drop

## 0.1.0

* Docking layout
  * Docking areas
* Initial version of drag and drop areas

## 0.0.1

* Package creation
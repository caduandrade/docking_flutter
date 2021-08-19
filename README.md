[![pub](https://img.shields.io/pub/v/docking.svg)](https://pub.dev/packages/docking) ![](https://github.com/caduandrade/docking_flutter/actions/workflows/test.yml/badge.svg) [![](https://img.shields.io/badge/demo-try%20it%20out-blue)](https://caduandrade.github.io/docking_flutter_demo/) [![pub2](https://img.shields.io/badge/Flutter-%E2%9D%A4-red)](https://flutter.dev/) ![pub3](https://img.shields.io/badge/final%20version-as%20soon%20as%20possible-blue)

# Docking

__*This package is still under developing*__

Layout for placing widgets in docking areas and arrange them into split and tabbed views.

![](https://raw.githubusercontent.com/caduandrade/images/main/docking/docking_v2.png)

## Usage

* [Layout](#layout)
  * [Row](#row)
  * [Column](#column)
  * [Tabs](#tabs)
  * [Combined](#combined)
* Item
  * [Non-closable](#non-closable)

## Layout

The layout is organized into areas: items (`DockingItem`), columns (`DockingColumn`), rows (`DockingRow`) and tabs (`DockingTabs`).
The root is single and can be any area.

![](https://raw.githubusercontent.com/caduandrade/images/main/docking/docking_layout_uml_v3.png)

### Row

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
```

![](https://raw.githubusercontent.com/caduandrade/images/main/docking/row_v2.png)

### Column

```dart
    DockingLayout layout = DockingLayout(
        root: DockingColumn([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
```

![](https://raw.githubusercontent.com/caduandrade/images/main/docking/column_v2.png)

### Tabs

```dart
    DockingLayout layout = DockingLayout(
        root: DockingTabs([
          DockingItem(name: '1', widget: child1),
          DockingItem(name: '2', widget: child2)
        ]));
    Docking docking = Docking(layout: layout);
```

![](https://raw.githubusercontent.com/caduandrade/images/main/docking/tabs_v1.png)

### Combined

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingColumn([
        DockingItem(name: '2', widget: child2),
        DockingTabs([
          DockingItem(name: '3', widget: child3),
          DockingItem(name: '4', widget: child4)
        ])
      ])
    ]));
    Docking docking = Docking(layout: layout);
```

![](https://raw.githubusercontent.com/caduandrade/images/main/docking/combined_v2.png)

## Item

### Non-closable

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2, closable: false)
    ]));
    Docking docking = Docking(layout: layout);
```

![](https://raw.githubusercontent.com/caduandrade/images/main/docking/nonclosable_v1.png)
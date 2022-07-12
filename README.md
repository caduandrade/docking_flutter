[![pub](https://img.shields.io/pub/v/docking.svg)](https://pub.dev/packages/docking) ![](https://github.com/caduandrade/docking_flutter/actions/workflows/test.yml/badge.svg) [![](https://img.shields.io/badge/demo-try%20it%20out-blue)](https://caduandrade.github.io/docking_flutter_demo/) [![pub2](https://img.shields.io/badge/Flutter-%E2%9D%A4-red)](https://flutter.dev/) [![](https://img.shields.io/badge/donate-crypto-green)](#support-this-project) ![](https://img.shields.io/badge/%F0%9F%91%8D%20and%20%E2%AD%90-are%20free-yellow)

# Docking

Layout for placing widgets in docking areas and arrange them into split and tabbed views.

![](https://caduandrade.github.io/docking_flutter/docking_v3.png)

## Usage

* [Layout](#layout)
  * [Row](#row)
  * [Column](#column)
  * [Tabs](#tabs)
  * [Combined](#combined)
* [Dependencies](#dependencies)
* Item
  * [Non-closable](#non-closable)
  * [Non-maximizable](#non-maximizable)
  * [Selection listener](#selection-listener)
  * [Close listener](#close-listener)
  * [Close interceptor](#close-interceptor)
  * [Buttons](#item-buttons)
* [Docking buttons build](#docking-buttons-build)
* [State](#state)
* Theme
  * [Divider](#divider-theme)
  * [Tabs](#tabs-theme)
* [Support this project](#support-this-project)

## Layout

The layout is organized into areas: items (`DockingItem`), columns (`DockingColumn`), rows (`DockingRow`) and tabs (`DockingTabs`).
The root is single and can be any area.

![](https://caduandrade.github.io/docking_flutter/docking_layout_uml_v4.png)

### Row

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
```

![](https://caduandrade.github.io/docking_flutter/row_v3.png)

### Column

```dart
    DockingLayout layout = DockingLayout(
        root: DockingColumn([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(layout: layout);
```

![](https://caduandrade.github.io/docking_flutter/column_v3.png)

### Tabs

```dart
    DockingLayout layout = DockingLayout(
        root: DockingTabs([
          DockingItem(name: '1', widget: child1),
          DockingItem(name: '2', widget: child2)
        ]));
    Docking docking = Docking(layout: layout);
```

![](https://caduandrade.github.io/docking_flutter/tabs_v2.png)

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

![](https://caduandrade.github.io/docking_flutter/combined_v3.png)

## Dependencies

This package uses two dependencies

* [multi_split_view](https://pub.dev/packages/multi_split_view) to provide horizontal or vertical split views
* [tabbed_view](https://pub.dev/packages/tabbed_view) to provide grouping of widgets into tabs

To use all the features provided by these dependencies, such as themes, you may need to import them into your project.

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

![](https://caduandrade.github.io/docking_flutter/nonclosable_v2.png)

### Non-maximizable

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2, maximizable: false)
    ]));
    Docking docking = Docking(layout: layout);
```

![](https://caduandrade.github.io/docking_flutter/nonmaximizable_v1.png)

### Selection listener

```dart
    DockingLayout layout = DockingLayout(
        root: DockingTabs([
          DockingItem(name: '1', widget: child1),
          DockingItem(name: '2', widget: child2),
          DockingItem(name: '3', widget: child3)
        ]));
    Docking docking = Docking(
        layout: layout,
        onItemSelection: (DockingItem item) {
          print(item.name!);
        });
```

### Close listener

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2),
      DockingItem(name: '3', widget: child3)
    ]));
    Docking docking = Docking(
        layout: layout,
        onItemClose: (DockingItem item) {
          _onItemClose(context, item);
        });
```

```dart
  void _onItemClose(BuildContext context, DockingItem item) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('item ' + item.name! + ' has been closed'),
        duration: const Duration(seconds: 3)));
  }
```

### Close interceptor

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingItem(name: '2', widget: child2)
    ]));
    Docking docking = Docking(
        layout: layout,
        itemCloseInterceptor: (DockingItem item) {
          return _checkItem(context, item);
        });
```

```dart
  bool _checkItem(BuildContext context, DockingItem item) {
    if (item.name == '1') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('item 1 can not be closed'),
          duration: const Duration(seconds: 3)));
      return false;
    }
    return true;
  }
```

### Item buttons

```dart
    import 'package:tabbed_view/tabbed_view.dart';
```

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
          DockingItem(name: '1', widget: child1),
          DockingColumn([
            DockingItem(name: '2', widget: child2),
            DockingItem(name: '3', widget: child3, buttons: [
              TabButton(
                      icon: IconProvider.data(Icons.add_circle_outline),
                      onPressed: () => _toast(context, 'add button')),
              TabButton(
                      icon: IconProvider.data(Icons.arrow_drop_down_outlined),
                      menuBuilder: (context) {
                        return [
                          TabbedViewMenuItem(
                                  text: 'Option 1',
                                  onSelection: () => _toast(context, '1')),
                          TabbedViewMenuItem(
                                  text: 'Option 2', onSelection: () => _toast(context, '2'))
                        ];
                      })
            ])
          ])
        ]));
Docking docking = Docking(layout: layout);
```

![](https://caduandrade.github.io/docking_flutter/item_buttons_v2.png)

## Docking buttons build

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingTabs([
        DockingItem(name: '2', widget: child2),
        DockingItem(name: '3', widget: child3)
      ])
    ]));
    Docking docking =
        Docking(layout: layout, dockingButtonsBuilder: _buttonsBuilder);
```

```dart
  List<TabButton> _buttonsBuilder(BuildContext context,
        DockingTabs? dockingTabs, DockingItem? dockingItem) {
  if (dockingTabs != null) {
    // docking area is a DockingTabs
    return [
      TabButton(
              icon: IconProvider.data(Icons.tag_faces_outlined),
              onPressed: () => print('Smile!'))
    ];
  }
  // docking area is a DockingItem
  return [
    TabButton(
            icon: IconProvider.data(Icons.access_time),
            onPressed: () => print('Time button!'))
  ];
}
```

![](https://caduandrade.github.io/docking_flutter/docking_buttons_build_v2.png)

## State

The drag action can change the tree structure due to a new arrangement of rows, columns or tabs.
The *keepAlive* parameter keeps the state during the layout change.
This feature implies using GlobalKeys and keeping the widget in memory even if the tab is not selected.

```dart
    DockingItem(name: 'myStatefulWidget', widget: myStatefulWidget, keepAlive: true);
```

## Theme

### Divider theme

You should use the *MultiSplitViewTheme* widget to apply the theme to all descendant widgets.

Read more information about themes on [multi_split_view](https://pub.dev/packages/multi_split_view).

```dart
    import 'package:multi_split_view/multi_split_view.dart';
```

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingColumn([
        DockingItem(name: '2', widget: child2),
        DockingItem(name: '3', widget: child3)
      ])
    ]));
    Docking docking = Docking(layout: layout);
    MultiSplitViewTheme theme = MultiSplitViewTheme(
        child: docking,
        data: MultiSplitViewThemeData(
            dividerThickness: 15,
            dividerPainter: DividerPainters.grooved2(
                backgroundColor: Colors.grey[700]!,
                color: Colors.grey[400]!,
                highlightedColor: Colors.white)));
    Container container = Container(
      padding: EdgeInsets.all(16),
      child: theme,
      color: Colors.grey[700]!,
    );
```

![](https://caduandrade.github.io/docking_flutter/divider_theme_v3.png)

### Tabs theme

You should use the *TabbedViewTheme* widget to apply the theme to all descendant widgets.

Read more information about themes on [tabbed_view](https://pub.dev/packages/tabbed_view).

```dart
    import 'package:tabbed_view/tabbed_view.dart';
```

```dart
    DockingLayout layout = DockingLayout(
        root: DockingRow([
      DockingItem(name: '1', widget: child1),
      DockingTabs([
        DockingItem(name: '2', widget: child2),
        DockingItem(name: '3', widget: child3)
      ])
    ]));
    Docking docking = Docking(layout: layout);
    TabbedViewTheme theme =
        TabbedViewTheme(child: docking, data: TabbedViewThemeData.mobile());
```

![](https://caduandrade.github.io/docking_flutter/tabs_theme_v2.png)

## Support this project

### Bitcoin

[bc1qhqy84y45gya58gtfkvrvass38k4mcyqnav803h](https://www.blockchain.com/pt/btc/address/bc1qhqy84y45gya58gtfkvrvass38k4mcyqnav803h)

### Ethereum (ERC-20) or Binance Smart Chain (BEP-20)

[0x9eB815FD4c88A53322304143A9Aa8733D3369985](https://etherscan.io/address/0x9eb815fd4c88a53322304143a9aa8733d3369985)

### Solana

[7vp45LoQXtLYFXXKx8wQGnzYmhcnKo1TmfqUgMX45Ad8](https://explorer.solana.com/address/7vp45LoQXtLYFXXKx8wQGnzYmhcnKo1TmfqUgMX45Ad8)

### Helium

[13A2fDqoApT9VnoxFjHWcy8kPQgVFiVnzps32MRAdpTzvs3rq68](https://explorer.helium.com/accounts/13A2fDqoApT9VnoxFjHWcy8kPQgVFiVnzps32MRAdpTzvs3rq68)
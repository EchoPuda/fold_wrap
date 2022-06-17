## Description
Fold Wrap can auto wrap, and also can fold excess rows or expand them. This Widget is suitable for scenarios similar to the history of the search page.

Folded

<img width="397" alt="image" src="https://user-images.githubusercontent.com/48596516/174257031-341a8af4-76a6-472d-be4f-2ef86378effd.png">

Expanded

<img width="396" alt="image" src="https://user-images.githubusercontent.com/48596516/174257173-766bb02e-0277-408c-8f59-8ad727bdd973.png">

## How to Use
Given `List<Widget>` and set which **line** needs to be **collapsed**, and can set `space` and `runSpace` like `Wrap`. And you should set the `extentHeight` for the **max height **of each row. Like that
```dart
FoldWrap(
    children: <Widget>[...],
    extentHeight: 30,
    spacing: 10,
    runSpacing: 10,
    isFold: ture, // controller fold
    foldLine: 2,
)
```

`foldWidget` can set the button at the end after folding.
```dart
FoldWrap(
  foldWidget: Icon(..),
  foldWidgetInEnd: true,
)
```

`foldWidgetInEnd` set that whether `foldWidget` is to be at the end of the line. Default is false.

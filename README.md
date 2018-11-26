[![License](https://img.shields.io/cocoapods/l/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)
[![Platform](https://img.shields.io/cocoapods/p/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)
[![Version](https://img.shields.io/cocoapods/v/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)

# Arale
A custom stretchy big head for UITableView, UICollectionView, or any UIScrollView subclasses.

# Demo
![Example 1](https://media.giphy.com/media/1qbl6sAB2EJh0fi9p7/giphy.gif)

# Arale, by [ZulwiyozaPutra](https://twitter.com/ZulwiyozaPutra)

- Compatible with `UITableView`, `UICollectionView`, or any `UIScrollView` subclasses.
- Data source and delegate independency: can be added to an existing view controller withouth interfering with your existing `delegate` or `dataSource`
- No need to subclass a custom view controller or to use a custom `UICollectionViewLayout`
- Simple usage: just implement your own subclass and add it to your `UIScrollView` subclass


If you are using this library in your project, I would be more than glad to [know about it!](mailto:zulwiyozaputra@gmail.com)

## Usage

To add a stretchy header to your table or collection view, you just have to do this:

```swift

import Arale

var araleHeaderView: HeaderView!

...

func viewDidLoad() {
  super.viewDidLoad()
  let araleHeaderView = HeaderView(minHeight: 256.0)
  araleHeaderView.delegate = self
  araleHeaderView.dataSource = self
  self.araleHeaderView.delegate = self
  self.araleHeaderView.dataSource = self
  self.tableView.addSubview(self.araleHeaderView)
}

...

// You need to conform your ViewController to HeaderViewDataSource
// observableScrollViewForHeaderView will return any UIScrollView children instance to be tracked by the HeaderView

func observableScrollViewForHeaderView() -> UIScrollView {
  guard let tableView = self.tableView else {
    fatalError()
  }
        
  return tableView
}

...

// In case you want to add a refreshControl
// To handle action if the HeaderView has resize to maxHeight you can use HeaderViewDelegate

func headerViewWillStartRefreshing() {
  // If you have a refreshControl in the HeaderView then it will start refreshing for you
  print("Handle Your Refreshing Action Here")
}
```

## Configuration

You can change multiple parameters in your stretchy header view:

```swift
// you can set the margin between the big head and your content to 0, the default is 16
araleHeaderView.bottomMargin = 0

// You can change the minimum and maximum content heights
araleHeaderView.minHeight = 64
araleHeaderView.maxHeight = 280
```

## Installation

Arale is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile, you can check the Example Podfile to see how it looks like:

```ruby
pod "Arale"
```

## Author

[Zulwiyoza Putra](https://twitter.com/zulwiyozaputra)

## Contributions

Contributions are more than welcome! If you find a solution for a bug or have an improvement, don't hesitate to [open a pull request](https://github.com/ZulwiyozaPutra/Arale/compare)!

## License

`Arale` is available under the MIT license. See the LICENSE file for more info.

If your app uses `Arale`, I'd be glad if you reach me via [Twitter](https://twitter.com/zulwiyozaputra) or via email.

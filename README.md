[![License](https://img.shields.io/cocoapods/l/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)
[![Platform](https://img.shields.io/cocoapods/p/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)
[![Version](https://img.shields.io/cocoapods/v/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)

# Arale
A custom stretchable header view for `UIScrollView` or any its subclasses with `UIActivityIndicatorView` support for reloading your content. Built for iOS 10 and later.

# Demo
![Example 1](https://media.giphy.com/media/1qbl6sAB2EJh0fi9p7/giphy.gif)

# Arale

- Compatible with `UITableView`, `UICollectionView`, or any `UIScrollView` subclasses.
- Data source and delegate independency: can be added to an existing view controller without interfering with your existing `delegate` or `dataSource`.
- No need to subclass a custom view controller or to use a custom `UICollectionViewLayout`.


If you are using this library in your project, I would be more than glad to [know about it!](mailto:zulwiyozaputra@gmail.com)

## Usage

To add a stretchy header to your table or collection view, you just have to do this:

```swift

import Arale
```

`init` with optional `backgroundImage`
```swift
let araleHeaderView = AraleHeaderView(minHeight: 256.0, backgroundImage: myBackgroundImage)
self.tableView.addSubview(araleHeaderView)
```

In case you want to add a `UIActivityIndicatorView`, to handle action if the `AraleHeaderView` did resize to `maxHeight` you can implement a `AraleHeaderViewDelegate` conformed `UIViewController`
```swift
araleHeaderView.delegate = self
```

You can implement `headerViewDidReachMaxHeight` method to get event when the `araleHeaderView` did reach the maximum height
```swift
func headerViewDidReachMaxHeight(_ headerView: AraleHeaderView) {
    NSLog("%@", "Start Refreshing")
    headerView.activityIndicatorView.stopAnimating()
}
```
`AraleHeaderViewDelegate` comes with three optional delegate method
```swift

func headerViewWillResizeFrame(_ headerView: AraleHeaderView)
func headerViewDidResizeFrame(_ headerView: AraleHeaderView)
func headerViewDidReachMaxHeight(_ headerView: AraleHeaderView)
```

## Configuration

You can add an optional `UIViewActivityIndicatorView` in your stretchy header view:
```swift
let myActivityIndicatorview = UIActivityIndicatorView(style: .white)
araleHeadeView.activityIndicatorView = myActivityIndicatorView
```

the `activityIndicatorView` will not be rendered if remain `nil` in case you don't need an activityIndicator.



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

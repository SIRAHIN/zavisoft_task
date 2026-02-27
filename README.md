# Zavisoft Flutter Task - Daraz Style Product Listing

This project implements a Daraz-style product listing screen in Flutter, featuring a collapsible header, a sticky tab bar, and a unified vertical scrolling experience using `NestedScrollView`.

## 1. How horizontal swipe was implemented

Horizontal swipe navigation is implemented using a **`TabBarView`** synchronized with a `TabController`. 
The `TabBarView` is placed inside the `body` of the `NestedScrollView`. It inherently provides smooth horizontal panning gestures. By relying on `TabBarView`, we delegate the horizontal gesture handling seamlessly to Flutter's native tab architecture, ensuring predictable switching between category tabs without accidentally triggering vertical scrolling or conflicting with other gestures.

## 2. Who owns the vertical scroll and why

The **`NestedScrollView`** is the absolute owner of the overall vertical scroll. 

**Why?**
The screen requires exactly *one* unified vertical scrolling experience that coordinates hiding the top banner and pinning the tab bar before allowing the list of products below to scroll up. 
If we used separate `ScrollController`s or `ListView`s without coordination, the UI would experience scroll jitter or duplicate scrolling. 
By placing the header elements (Search Bar, Banner, and TabBar) inside the `headerSliverBuilder` of the `NestedScrollView` and the `TabBarView` (containing the lists) in the `body`, the `NestedScrollView` perfectly coordinates the scroll offset. It consumes scroll delta from the inner `GridView`s, scrolls the outer slivers up until the sticky `TabBar` hits the top, and only then allows the inner `GridView` to scroll internal items.

## 3. Trade-offs or limitations of the approach

While `NestedScrollView` is powerful for coordinated scrolling, it comes with specific architectural trade-offs, particularly regarding tab state preservation and shared scroll controllers.

**The Scroll Position Retention Issue (Current Limitation):**
You might notice that switching tabs occasionally causes a `GridView`'s scroll position to jump or reset. 
In the current implementation, `AutomaticKeepAliveClientMixin` was added to `ProductCardWidget` (the individual grid items). Unfortunately, this does not keep the *scroll position* of the `GridView` itself alive. 

When a user swipes horizontally, `TabBarView` disposes of off-screen pages to save memory. Because the `AutomaticKeepAliveClientMixin` is not applied at the **page level** (i.e. on `ProductHolder`), the `GridView` itself is torn down when you swipe away, taking its scroll position with it.

**How to fix this limitation:**
1. **Move KeepAlive to the Holder:** Move `with AutomaticKeepAliveClientMixin` from `_ProductCardWidgetState` to `_ProductHolderState` and importantly, make sure to call `super.build(context)` as the first line in its `build` method.
2. **Page Storage Keys:** Give each `GridView.builder` inside `ProductHolder` a unique key, like `key: PageStorageKey(widget.category)`. `NestedScrollView` relies on `PageStorageKey`s to differentiate and save the active inner scroll position for each tab view.
3. **Internal NestedScrollView complexities:** `NestedScrollView` forces the inner and outer scrollables to share one unified Scroll Position logic. This can make adding `RefreshIndicator` tricky. Currently, it's wrapped around the inner `GridView`, meaning pull-to-refresh will work per-tab, but sometimes only cleanly when the outer scroll is completely expanded.

Using `NestedScrollView` avoids fragile hacks or global scroll listeners, but it heavily relies on Flutter's internal `Sliver` math working in tandem with Keep-Alive mechanisms on the nested pages to be completely seamless.

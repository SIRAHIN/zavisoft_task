# Zavisoft Flutter Task — Daraz-Style Product Listing

---

## 1. How Horizontal Swipe Was Implemented

I used Flutter's built-in `TabBarView` with a shared `TabController`.

`TabBarView` handles horizontal swipe natively. It lets the user either tap a tab or swipe left/right to switch categories. Because it uses Flutter's own gesture system, it does not interfere with vertical scrolling. The swipe is horizontal-only — it does not trigger or control any vertical scroll.

---

## 2. Who Owns the Vertical Scroll and Why

**`NestedScrollView` owns the vertical scroll — and only it.**

Here is why this design was chosen:

The screen needs one single vertical scroll that:
- Hides the banner at the top when scrolling down
- Pins (sticks) the tab bar once the banner is gone
- Then lets the product grid scroll inside

If I used a regular `GridView` inside each tab, each tab would have its own scroll — meaning the header would never collapse properly, and the tab bar would never pin. There would also be scroll conflicts (two scrollables fighting each other).

By putting the header slivers (Search Bar, Banner, TabBar) inside `NestedScrollView`'s `headerSliverBuilder`, and the `TabBarView` in the `body`, all vertical scrolling is handled in one place with no conflict.

---

## 3. Trade-offs and Limitations

### The Scroll Position Problem (Current Known Limitation)

When i try to scrolls down in one tab, switches to another tab, the scroll position hold exactly same for evey tab view.

**Why this happens:**

`NestedScrollView` manages one unified scroll position for the whole screen. The inner scrollables (the `GridView` inside each tab) share this scroll coordination. When you switch tabs, `TabBarView` can dispose the off-screen page, which destroys the `GridView` and loses its scroll offset.

---

### What I Tried to Fix It

**Attempt 1 — `AutomaticKeepAliveClientMixin` on the card widget (`ProductCardWidget`)**

I added `AutomaticKeepAliveClientMixin` to each grid card, hoping it would keep the grid alive. This did **not** work. Keep-alive on an individual card only keeps that one widget in memory — it does not preserve the scroll position of the entire `GridView`. The grid itself still got rebuilt on tab switch.

**Attempt 2 — Moved `AutomaticKeepAliveClientMixin` to the page level (`ProductHolder`) + `PageStorageKey` on `GridView`**

I moved the mixin to `ProductHolder` (the whole tab page) and added a `PageStorageKey('grid_${category}')` to each `GridView`. This tells Flutter to remember and restore the scroll offset per-tab.

This gave some improvement — pages were kept alive in memory — but the scroll restoration was still inconsistent. The `NestedScrollView` coordinates inner and outer scroll positions at a low level, and `PageStorageKey` alone cannot fully override that behavior. The grid sometimes still jumps back to the top.

**Attempt 3 — Replaced `NestedScrollView` with `CustomScrollView`**

I tried using `CustomScrollView` with `SliverAppBar` and `SliverFillRemaining` (containing the `TabBarView`). Inside each tab, I gave the `GridView` its own `ScrollController`.

**Result:** The `GridView` did hold its scroll position when switching tabs. However, it broke the unified scroll experience. Scrolling inside the grid moved only the grid — not the whole page. The header (banner + search bar) would not collapse. The tab bar would not pin. Each tab's grid scrolled independently instead of as one page. So the core requirement (single vertical scroll, collapsible header) was broken.

---

### Summary

| Approach | Scroll Position Saved | Header Collapses | Tab Bar Pins |
|---|---|---|---|
| `NestedScrollView` (current) | ❌ hold exactly same for evey tab view | ✅ Yes | ✅ Yes |
| `CustomScrollView` per-tab | ✅ Saved | ❌ No | ❌ No |

The core task requirement — one vertical scroll, collapsible header, sticky tab bar — points to `NestedScrollView` as the correct architecture. The scroll position limitation is a known trade-off of this approach in Flutter.

A production solution would require a custom `ScrollController` that synchronizes the inner and outer scroll positions manually, or a state management approach that stores and restores the exact scroll offset when a tab becomes active again.


## 📱 App Screenshots  

## Splash Screen
<img width="250" alt="Simulator Screenshot - iPhone 16 Plus - 2026-02-28 at 01 13 23" src="https://github.com/user-attachments/assets/51ba9f65-e160-4a4e-a359-2084ec12b444" />

## Login Page
<img width="250" alt="Simulator Screenshot - iPhone 16 Plus - 2026-02-28 at 01 13 25" src="https://github.com/user-attachments/assets/ea4a8ae1-e383-4e97-9724-1b8c1919818e" />

## Home Page
<img width="250" alt="Simulator Screenshot - iPhone 16 Plus - 2026-02-28 at 01 13 02" src="https://github.com/user-attachments/assets/10471304-1cf8-4bfd-b353-f54462184567" />
<img width="250" alt="Simulator Screenshot - iPhone 16 Plus - 2026-02-28 at 01 13 05" src="https://github.com/user-attachments/assets/80e6d795-de81-4a32-895e-485fcac42dae" />

## Account Page
<img width="250" alt="Simulator Screenshot - iPhone 16 Plus - 2026-02-28 at 12 31 43" src="https://github.com/user-attachments/assets/affa30e3-1f78-423d-a2ec-f6941fc87c36" />




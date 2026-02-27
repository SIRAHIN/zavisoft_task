import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavisoft_task/viewmodels/cubit/product_cubit.dart';
import 'package:zavisoft_task/viewmodels/cubit/product_state.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/home_fragment/widgets/banner_widget.dart';
import 'package:zavisoft_task/views/bottom_nav_view/fragments/home_fragment/widgets/product_holder.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getCategory();
  }

  // Call this once categories are loaded from API
  void _initTabController(List<String> categories) {
    // Dispose old controller if it exists
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();

    _tabController = TabController(length: categories.length, vsync: this);
    _tabController!.addListener(_onTabChanged);

    // Load first category products
    if (categories.isNotEmpty) {
      context.read<ProductCubit>().getProducts(categories[0]);
    }
  }

  void _onTabChanged() {
    if (_tabController == null || _tabController!.indexIsChanging) return;
    final categories = context.read<ProductCubit>().state.categoryType;
    if (categories.isEmpty) return;
    final cat = categories[_tabController!.index];
    context.read<ProductCubit>().getProducts(cat);
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,

        // NestedScrollView is the main who is own the vertical scroll of the screen \\
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            
            // Pinned Search Bar \\
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: false,
              pinned: true,
              titleSpacing: 12,
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.pink),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.pink),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.pink, width: 2),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.pink,
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Banner
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: BannerWidget(),
              ),
            ),

            // Pinned TabBar
            SliverAppBar(
              pinned: true,
              floating: false,
              elevation: 0,
              backgroundColor: Colors.white,
              collapsedHeight: 0,
              toolbarHeight: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: BlocConsumer<ProductCubit, ProductState>(
                  listener: (context, state) {
                    if (state.categoryType.isNotEmpty &&
                        (_tabController == null ||
                            _tabController!.length !=
                                state.categoryType.length)) {
                      _initTabController(state.categoryType);
                    }
                  },
                  builder: (context, state) {
                    print("This is state ${state.categoryType}");
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (_tabController == null ||
                        state.categoryType.isEmpty) {
                      return const Center(child: Text('No categories found'));
                    }
                    return TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      labelColor: Colors.orange,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.orange,
                      tabs: state.categoryType
                          .map((e) => Tab(text: e))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ],

          //  TabBarView
          body: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state.categoryType.isEmpty || _tabController == null) {
                return Center(child: CircularProgressIndicator());
              }
              return TabBarView(
                controller: _tabController,
                children: state.categoryType.map((cat) {
                  return ProductHolder(category: cat);
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

}

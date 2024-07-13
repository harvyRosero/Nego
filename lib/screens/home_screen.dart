import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:agro/widgets/home_screen_widgets.dart';
import 'package:agro/controllers/home_controller.dart';
import 'package:flutter/scheduler.dart';
import 'package:agro/widgets/snackbars.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isBottomNavBarVisible = ValueNotifier(true);
  final ValueNotifier<bool> _isFabVisible = ValueNotifier(true);
  final HomeController _homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _homeController.getDataPublic();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isBottomNavBarVisible.value) _isBottomNavBarVisible.value = false;
      if (_isFabVisible.value) _isFabVisible.value = false;
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isBottomNavBarVisible.value) _isBottomNavBarVisible.value = true;
      if (!_isFabVisible.value) _isFabVisible.value = true;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _isBottomNavBarVisible.dispose();
    _isFabVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _homeController.getDataPublic(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                buildSliverAppBar(_refreshData),
              ],
            );
          } else if (snapshot.hasError) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              SnackbarUtils.warning('No se encontraron datos...');
            });
            return const Center(child: Text('Cargando...'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                buildSliverAppBar(_refreshData),
              ],
            );
          } else {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                buildSliverAppBar(_refreshData),
                buildSliverList(snapshot.data!),
              ],
            );
          }
        },
      ),
      bottomNavigationBar:
          buildAnimatedBottomNavigationBar(_isBottomNavBarVisible),
      floatingActionButton: buildAnimatedFloatingActionButton(_isFabVisible),
    );
  }
}

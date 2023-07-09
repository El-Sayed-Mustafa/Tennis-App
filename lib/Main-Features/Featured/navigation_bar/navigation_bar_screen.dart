import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_app/Main-Features/Featured/navigation_bar/widgets/navigation_bar_item.dart';
import '../../chats/chat_screen.dart';
import '../../club/club_screen.dart';
import '../../home/home_screen.dart';
import '../../menu/menu_screen.dart';
import 'cubit/navigation_cubit.dart';

class NavigationBarScreen extends StatelessWidget {
  const NavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state,
            children: const [
              HomeScreen(),
              ClubScreen(),
              ChatScreen(),
              MenuScreen(),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: state,
            height: 60.0,
            items: const [
              NavigationBarItem(
                icon: Icons.home_outlined,
                label: 'Home',
                index: 0,
              ),
              NavigationBarItem(
                icon: Icons.sports_tennis,
                label: 'Club',
                index: 1,
              ),
              NavigationBarItem(
                icon: Icons.message_outlined,
                label: 'Chat',
                index: 2,
              ),
              NavigationBarItem(
                icon: Icons.menu,
                label: 'Menu',
                index: 3,
              ),
            ],
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 51, 64, 71),
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 400),
            onTap: (index) {
              final navigationCubit = context.read<NavigationCubit>();
              navigationCubit.selectPage(index);
            },
            letIndexChange: (index) => true,
          ),
        );
      },
    );
  }
}

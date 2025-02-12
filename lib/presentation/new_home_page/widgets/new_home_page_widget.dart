import 'package:cybear_jinni_site/application/new_home_page/new_home_page_bloc.dart';
import 'package:cybear_jinni_site/presentation/new_home_page/widgets/tab_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewHomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return BlocBuilder<NewHomePageBloc, NewHomePageState>(
      builder: (context, state) {
        return state.map(
          (value) => const Text('sd'),
          loading: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          loaded: (loadedState) {
            final PageController pageController = PageController();

            bool scrollAnimationCompleted = false;

            int currentPage = loadedState.currentPage;
            const int numberOfPages = 3;

            Future.delayed(const Duration(milliseconds: 100))
                .then((value) async {
              pageController.animateToPage(
                loadedState.currentPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linearToEaseOut,
              );
              currentPage = loadedState.currentPage;
              await Future.delayed(const Duration(milliseconds: 100));
              scrollAnimationCompleted = true;
            });

            return Listener(
              onPointerSignal: (pointerSignal) {
                if (pointerSignal is PointerScrollEvent &&
                    scrollAnimationCompleted) {
                  final double scrollAmount = pointerSignal.scrollDelta.dy;

                  if (scrollAmount > 0 && currentPage + 1 < numberOfPages) {
                    currentPage++;
                  } else if (scrollAmount < 0 && currentPage - 1 > -1) {
                    currentPage--;
                  } else {
                    return;
                  }
                  context.read<NewHomePageBloc>().add(
                        NewHomePageEvent.scrollPage(
                          pageController.page!,
                          currentPage,
                        ),
                      );
                }
              },
              child: Stack(
                children: [
                  PageView(
                    controller: pageController,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ColoredBox(
                        color: Colors.amber,
                        child: Center(
                          child: ListView(
                            children: [
                              TextButton(
                                onPressed: () {
                                  context.read<NewHomePageBloc>().add(
                                        NewHomePageEvent.scrollPage(
                                          loadedState.scrollPosition,
                                          currentPage++,
                                        ),
                                      );
                                },
                                child: const Text('Next Page'),
                              ),
                              const Text('First Page'),
                            ],
                          ),
                        ),
                      ),
                      const ColoredBox(
                        color: Colors.blue,
                        child: Center(
                          child: Text('Second Page'),
                        ),
                      ),
                      const ColoredBox(
                        color: Colors.red,
                        child: Center(
                          child: Text('Third Page'),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TabIndicator(numberOfPages, currentPage),
                  ),
                ],
              ),
            );
          },
          error: (_) {
            return const Text('Error');
          },
        );
      },
    );
  }
}

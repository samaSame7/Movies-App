import 'package:flutter/material.dart';

class AvatarSelector extends StatefulWidget {
  final List<String> avatars;
  final Function(int) onAvatarSelected;
  const AvatarSelector({super.key, required this.avatars, required this.onAvatarSelected});

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late PageController _controller;
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.35,
      initialPage: selectedIndex,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAvatarSelected(selectedIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _updateSelectedIndex(int index) {
    setState(() => selectedIndex = index);
    widget.onAvatarSelected(index);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        clipBehavior: Clip.none,
        controller: _controller,
        itemCount: widget.avatars.length,
        onPageChanged: (index) {
          _updateSelectedIndex(index);
        },
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isSelected ? 1.5 : 0.85,
            child: GestureDetector(
              onTap: () {
                _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                _updateSelectedIndex(index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,
                vertical: 10),
                child: Container(margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset(
                      widget.avatars[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

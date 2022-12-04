import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class GTKAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  const GTKAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    WindowManager wm = WindowManager.instance;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: onPanStart,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                if (ModalRoute.of(context)!.canPop)
                  Positioned(
                    left: 0,
                    child: InkWell(
                      hoverColor: Colors.white12,
                      borderRadius: BorderRadius.circular(7),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back_rounded, size: 17,),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                Center(child: title),
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        TitleButton(
                          onPressed: wm.minimize,
                          icon: Icons.minimize_rounded,
                        ),
                        const SizedBox(width: 14),
                        TitleButton(
                          onPressed: wm.close,
                          icon: Icons.close_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPanStart(DragStartDetails details) async {
    final WindowManager wm = WindowManager.instance;
    await wm.startDragging();
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}

class TitleButton extends StatelessWidget {
  const TitleButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.square(24),
      child: Material(
        color: Colors.white10,
        shape: const CircleBorder(),
        child: IconButton(
          color: Colors.white,
          icon: Icon(icon),
          iconSize: 14,
          padding: EdgeInsets.zero,
          splashRadius: 12,
          onPressed: () => onPressed(),
        ),
      ),
    );
  }
}

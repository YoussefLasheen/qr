import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class GTKAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  const GTKAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    WindowManager wm = WindowManager.instance;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[850]
            : const Color(0xFFebebeb),
        border: Border(
          bottom: BorderSide(
            color: isDark?Colors.black45:Colors.grey[300]!,
            width: 1,
          ),
        ),
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
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 17,
                        ),
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.fromSize(
      size: const Size.square(24),
      child: Material(
        color: isDark?Colors.white10:const Color(0xFFd9d9d9),
        shape: const CircleBorder(),
        child: IconButton(
          color: isDark?Colors.white:Colors.black,
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

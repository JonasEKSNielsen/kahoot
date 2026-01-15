import 'package:flutter/material.dart';

class DefaultAppbar extends StatelessWidget implements PreferredSizeWidget{
  const DefaultAppbar({super.key, this.title});
  final String? title;

  @override
  // Custom button with image and text
  Widget build(BuildContext context) => AppBar(
      title: title != null ? Text(
        title!,
        style: Theme.of(context).textTheme.headlineMedium,
      ) : null,
  );
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
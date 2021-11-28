import 'package:flutter/material.dart';

class SidebarTile extends StatelessWidget {
  const SidebarTile({
    Key? key,
    required this.leading,
    required this.title,
    this.isSelected = false,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.centered = false,
    this.onTap,
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets innerPadding;
  final bool centered;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment:
                centered ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Theme(
                data: theme.copyWith(
                  iconTheme: theme.iconTheme.copyWith(
                    color:
                        isSelected ? theme.primaryColor : theme.iconTheme.color,
                  ),
                ),
                child: leading,
              ),
              DefaultTextStyle(
                style: theme.textTheme.bodyText2!.copyWith(
                  color: isSelected
                      ? theme.primaryColor
                      : theme.textTheme.bodyText2!.color,
                ),
                child: Padding(
                  padding: innerPadding,
                  child: title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gsure/shared/theme.dart';

class CustomFilledButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Color? color;
  final Function()? onPressed;

  const CustomFilledButton({
    super.key,
    required this.title,
    this.color,
    this.width = double.infinity,
    this.height = 50,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color ?? primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: whiteTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final bool isDisabled;
  final VoidCallback onPressed;

  const BuildButton({
    super.key,
    required this.title,
    required this.iconData,
    this.isDisabled = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    backgroundColor: isDisabled ? Colors.grey : primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 10,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}

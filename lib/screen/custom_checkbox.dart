import 'package:flutter/material.dart';

class CustomTypeCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;
  final String typeName;
  final Color backgroundColor;

  const CustomTypeCheckbox(
      {super.key,
      required this.isChecked,
      required this.onTap,
      required this.backgroundColor,
      required this.typeName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isChecked ? backgroundColor : Colors.transparent,
        ),
        child: isChecked
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    typeName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: backgroundColor,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    typeName,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
      ),
    );
  }
}

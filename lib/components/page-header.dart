import 'package:flutter/material.dart';
import 'package:han4you/components/design/typography.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  PageHeader({@required this.title, @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 75),
        Center(
          child: Text(
            this.title,
            style: TypographyStyles.title
          ),
        ),
        Center(
          child: Text(
            this.subtitle,
            style: TypographyStyles.subtitle,
          ),
        ),
      ],
    );
  }
}

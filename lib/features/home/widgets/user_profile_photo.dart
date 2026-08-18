import 'package:cached_network_image/cached_network_image.dart';
import 'package:dk_docs/auth/models/user_model.dart';
import 'package:dk_docs/shared/resources/colors.dart';
import 'package:dk_docs/shared/themes/app_fonts.dart';
import 'package:flutter/material.dart';

Widget customUserProfile({
  required BuildContext context,
  required UserModel user,
}) {
  final userColor = CustomColors.getUserColor(user.uid);
  return SizedBox(
    width: 35,
    height: 35,

    child: CachedNetworkImage(
      imageBuilder: (context, imageProvider) {
        return Container(
          clipBehavior: .hardEdge,
          width: 35,
          height: 40,
          decoration: BoxDecoration(
            shape: .circle,
            image: DecorationImage(image: imageProvider, fit: .cover),
          ),
        );
      },

      memCacheWidth: 70,
      memCacheHeight: 70,

      maxWidthDiskCache: 70,
      maxHeightDiskCache: 70,
      imageUrl: user.photoUrl,
      errorWidget: (context, url, error) {
        final name = user.name.trim();

        final initials = name.isEmpty
            ? ''
            : name.split(RegExp(r'\s+')).take(2).map((e) => e[0]).join();
        return Container(
          decoration: BoxDecoration(
            color: userColor,

            borderRadius: .circular(25),
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                initials,
                style: TextStyle(
                  fontFamily: AppFonts.hubotSans,
                  fontSize: 25,
                  color: getTextColor(userColor),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

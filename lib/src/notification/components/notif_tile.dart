import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:intl/intl.dart';

class NotifTile extends StatelessWidget {
  NotifTile({
    Key? key,
    required this.date,
    required this.image,
    required this.notification,
    required this.notifier,
    required this.onDelete,
  });
  final VoidCallback onDelete;
  final String? image;
  final String notifier;
  final String notification;
  final DateTime? date;
  final DateFormat dateFormat = DateFormat("MMMM dd");
  @override
  Widget build(BuildContext context) {
    String formattedDate = dateFormat.format(date!);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 25,
            foregroundImage: NetworkImage(
              image ?? avatarDefault,
            ),
            backgroundImage: const NetworkImage(avatarDefault),
          ),
          SizedBox(
            width: 250,
            child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: notifier,
                      style: const TextStyle(
                          color: myBlue1,
                          decoration: TextDecoration.underline,
                          fontSize: 18),
                    ),
                    TextSpan(
                        text: ' $notification .',
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 18)),
                    TextSpan(
                        text: formattedDate,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18)),
                  ],
                )),
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black87,
              size: 30,
            ),
            onSelected: (value) {
              if (value == 'delete') {
                onDelete(); // Call the onDelete callback when delete is selected
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete', // Assign a value to the delete option
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.trashCan,
                      color: Colors.black87,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

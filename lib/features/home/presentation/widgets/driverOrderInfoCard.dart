import 'package:flutter/material.dart';

class DriverOrderInfoCard extends StatelessWidget {
  final String? image;
  final String title;
  final String subtitle;
  final bool isStore;

  const DriverOrderInfoCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isStore,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isStore ? const Color(0xFFE91E63) : Colors.grey[300],
              image: image != null
                  ? DecorationImage(
                      image: NetworkImage(image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: image == null
                ? Icon(
                    isStore ? Icons.store : Icons.person,
                    color: Colors.white,
                  )
                : null,
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
                SizedBox(height: height * 0.005),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: width * 0.035,
                      color: Colors.black54,
                    ),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

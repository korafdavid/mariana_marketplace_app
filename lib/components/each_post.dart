import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/views/classified_full_display.dart';
import 'package:mariana_marketplace/views/classifieds_screen.dart';
import 'package:mariana_marketplace/components/fav_button.dart';
import 'package:mariana_marketplace/controller/AuthState.dart';
import 'package:provider/provider.dart';

class EachPost extends StatefulWidget {
  //  final Color background;
  // final Map post;
  final String title;
  final String price;
  final String description;
  final String thumbnailID;
  final String classifiedID;

  EachPost({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    required this.thumbnailID,
    required this.classifiedID,
  }) : super(key: key);

  @override
  State<EachPost> createState() => _EachPostState();
}

class _EachPostState extends State<EachPost> {
  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: true);
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClassifiedDisplayScreen(
                    classifiedID: widget.classifiedID,
                  )),
        )
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        margin: EdgeInsets.only(bottom: 25, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: widget.title,
              child: classifiedThumbnail(
                "6259fa52f2266bd32b41",
                widget.thumbnailID,
                118,
                142,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                      favButton(
                          isfavorite: state.isFavorite(widget.classifiedID),
                          classifiedID: widget.classifiedID,
                          classified_type: "standard")
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style:
                        const TextStyle(color: Color(0xFF706965), height: 1.3),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$' + widget.price,
                    style: TextStyle(
                        color: Color(0xFF706965),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

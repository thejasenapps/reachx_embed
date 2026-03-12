import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class TextTilesWidget extends StatefulWidget {
  Set<String> tiles;
  String label;
  TextTilesWidget({super.key, required this.tiles, required this.label});

  @override
  State<TextTilesWidget> createState() => _TextTilesWidgetState();
}

class _TextTilesWidgetState extends State<TextTilesWidget> {

  TextEditingController tileController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        TextField(
          controller: tileController,
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: HexColor(containerBorderColor),
              )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: HexColor(containerBorderColor),
                )
            ),
          ),
          onTapOutside: (value) {
            setState(() {
              if(tileController.text.isNotEmpty) {
                widget.tiles.add(tileController.text);
              }
              tileController.clear();
            });
          },
          onSubmitted: (value) {
            setState(() {
              if(tileController.text.isNotEmpty) {
                widget.tiles.add(tileController.text);
              }
              tileController.clear();
            });
          },
        ),
        if(widget.tiles.isNotEmpty)
          Wrap(
            children: widget.tiles.map((tile) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor(containerBorderColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 35,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.tiles.remove(tile);
                              });
                            },
                            icon: const Icon(
                              Icons.cancel,
                              size: 14,
                            )
                        ),
                        Text(
                            tile,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                )
              );
            }).toList(),
          )
      ],
    );
  }
}

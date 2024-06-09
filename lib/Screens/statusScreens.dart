import 'package:c_box/Modals/StatusModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class Statuscreens extends StatefulWidget {
  final StatusModel status;
  const Statuscreens({super.key, required this.status});

  @override
  State<Statuscreens> createState() => _StatuscreensState();
}

class _StatuscreensState extends State<Statuscreens> {
  StoryController controller= StoryController();
  List<StoryItem> storyItem=[];
  
  
  
  void storyPageItem()
  {
    for(int i=0;i<widget.status.photoUrl.length ; i++)
      {
        StoryItem.pageImage(url: widget.status.photoUrl[i], controller: controller);
      }
  }
  @override
  void initState() {
    // TODO: implement initState
    print(widget.status.photoUrl);
    super.initState();
    storyPageItem();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItem.isEmpty ? Center(child: CircularProgressIndicator(),): 
      StoryView(storyItems: storyItem, controller: controller),
    );
  }
}

import 'package:flutter/material.dart';
//import 'package:path/path.dart';
import '../screens/taskuncom.dart'; // Import for unnamed pages
import '../screens/goalpage.dart'; // Import for unnamed pages
import '../screens/camerascreen.dart'; // Import for unnamed pages

//unnamed pages are ones where we need to know argeuments before loading (for example taskid)
//add more above this if needed 


void goBack<T>(BuildContext context,[T? result]){//This is basicly useless, and only here for consistancy
  Navigator.pop(context, result); //specify the type <T> you are returning, if you do return something
}

void gotoNamed(BuildContext context,String name, [Function? refreshCallback])async { //This can force a refresh
  final shouldRefresh = await Navigator.pushNamed(context,name);
  if(shouldRefresh==true){refreshCallback?.call();}
}

void gotoNamedReplace(BuildContext context,String name)async{ //This is basicly useless, and only here for consistancy and because that is the function used for the bottom bar
      await Navigator.pushReplacementNamed(context,name);
}

//Bellow will try to be a generic function to go to unnamed pages. For now it works with goals and tasks, intent is to work with all such pages
//Documentation
//Context is always just context
//Type declares what page you want to go to
//userid,pageid (other args) determine the page you will go to
//refreshCallback is the function you want to run to refresh the page, usually altering the state (for example loaditems in home) it can be kept empty by default to avoid a refresh

//this is a helper enum to make it compile-safe to declare pages types at functions.
//Add future pages here
enum PageType {
  task,
  goal,
  camera
}

void gotoUnnamed(BuildContext context, PageType type, int userid, int pageid, [Function? refreshCallback] ) async {

  bool shouldRefresh = false;

  if(type==PageType.task){
    shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(
          userId: userid,
          taskId: pageid,
        ),
      ), 
    );
  }

  else if(type == PageType.goal){
    shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalDetailsScreen(
          userId: userid,
          goalId: pageid,
        ), 
      ), 
    );      
  }

  else if(type == PageType.camera){
    //shouldRefresh=true;
    final capturedImagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            userId: userid,
            taskId: pageid
          ),
        ),
      );
      //this may need rework, but for now mimics current camera behaviour. Seems kinda useless
      //I dont like the fact the return function is built in and not custom.
      if (capturedImagePath != null) {
        shouldRefresh=true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo captured: $capturedImagePath')),
        );
      }
  } 
  
  //add here more pages


  if (shouldRefresh == true) {
    refreshCallback?.call(); //questionmark doesnt call the function if its null
  }

}
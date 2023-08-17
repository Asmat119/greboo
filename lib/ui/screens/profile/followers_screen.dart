import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grebooo/core/models/FollowersModel.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/profile/controller/ProfileChangeController.dart';
import 'package:grebooo/ui/screens/profile/profile.dart';
import 'package:get/get.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({Key? key, required this.follower_type})
      : super(key: key,);
  final FOLLOWER_TYPE follower_type;

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final ProfileChangeController profileChangeController = Get.put(
      ProfileChangeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // profileChangeController.getFollowers(widget.follower_type);
  }


  @override
  Widget build(BuildContext context) {
    print(profileChangeController.followingList.length);
    return SafeArea(
      child:
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.green, title: Text(widget.follower_type
            == FOLLOWER_TYPE.following ? "Following" : "Follower")),
        body:

        Obx(() {
          return Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: profileChangeController.followingList.value.isEmpty
                    ? const Center(child: Text("No record found!"))
                    :ListView.builder(itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(blurRadius: 10,
                              spreadRadius: 10,
                              color: Colors.black12)
                        ],


                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Obx(() {
                      return ListTile(

                        leading: Container(

                          width: 46, height: 46, decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: Colors.green)

                        ),
                          child: profileChangeController.followingList
                              .value[index]
                              .image == '' ? const Icon(
                            Icons.account_circle, color: Colors.blue,) :


                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image
                                .network(
                              profileChangeController.followingList
                                  .value[index]
                                  .image, fit: BoxFit.cover,),
                          ),
                        ),
                        title: Text(profileChangeController.followingList
                            .value[index].name, style: const TextStyle(
                            color: Colors.black),),
                      );
                    }),
                  );
                },
                  itemCount: profileChangeController.followingList.value
                      .length,

                )
            ),
          );
        }),
      ),

    );
  }


}

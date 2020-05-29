import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Group {
  Color color;
  String title;

  Group({
    this.color, this.title
  });

  Group.fromJson(Map<String, dynamic> json)
      : color = Color(json['color']),
        title = json['title'];

  Map<String, dynamic> toJson() =>
      {
        'color': color.value,
        'title': title
      };
}
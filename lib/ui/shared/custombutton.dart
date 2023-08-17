import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/config.dart';

class ButtonProps {
  double height;
  double radius;
  TextStyle textStyle;
  BoxBorder? border;
  Color backgroundColor;
  ButtonProps({
    required this.height,
    required this.radius,
    required this.textStyle,
    required this.backgroundColor,
    this.border,
  });
}

class CustomButton extends StatefulWidget {
  final CustomButtonType type;
  final String text;
  final Function()? onTap;
  final double width;
  final ButtonProps props;
  final double padding;

  CustomButton(
      {required this.type,
      required this.text,
      required this.onTap,
      this.width = 0,
      props,
      this.padding = 0})
      : props = props ?? type.props;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.padding),
        width: widget.width == 0 ? double.infinity : widget.width,
        height: widget.props.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.props.radius),
            ),
            color: widget.props.backgroundColor,
            border: widget.props.border),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(widget.text, style: widget.props.textStyle),
        ),
      ),
      // ),
    );
  }
}

Widget socialButton(String image, Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 48,
      width: getProportionateScreenWidth(89),
      child: SvgPicture.asset(
        image,
        fit: BoxFit.fill,
      ),
    ),
  );
}

class BusinessCategories extends StatefulWidget {
  final Function()? onTap;
  final double? height;
  final Color? backgroundColor;
  final Border? border;
  final String text;
  final TextStyle? textStyle;

  const BusinessCategories(
      {this.onTap,
      this.height,
      this.backgroundColor,
      this.border,
      required this.text,
      this.textStyle});

  @override
  _BusinessCategoriesState createState() => _BusinessCategoriesState();
}

class _BusinessCategoriesState extends State<BusinessCategories> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            // margin: EdgeInsets.only(right: getProportionateScreenWidth(10)),
            // height: widget.height,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(
            //       Radius.circular(50),
            //     ),
            //     color: widget.backgroundColor,
            //     border: widget.border),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(16),
                  bottom: getProportionateScreenHeight(16),
                  left: getProportionateScreenWidth(16),
                  right: getProportionateScreenWidth(16)),
              child: Column(
                children: [
                  Expanded(child: Icon(Icons.accessibility_sharp)),
                  SizedBox(height: 6,),
                  Expanded(child: Text(widget.text, style: widget.textStyle, textAlign: TextAlign.center,)),
                ],
              ),
            ),
          ),
          // ),
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}

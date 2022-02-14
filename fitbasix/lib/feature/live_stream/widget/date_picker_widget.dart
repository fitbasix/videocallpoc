import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/color_palette.dart';
import '../../../core/reponsive/SizeConfig.dart';

class CustomDatePickerWidget extends StatefulWidget {
  DateTime? currentDate;
  ValueChanged<DateTime>? onChanged;
   CustomDatePickerWidget({Key? key,this.currentDate,this.onChanged}) : super(key: key);

  @override
  _CustomDatePickerWidgetState createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  int selectedIndex = 0;

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    return days;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16 * SizeConfig.widthMultiplier!,
          right: 16 * SizeConfig.widthMultiplier!),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {

              List<DateTime> date = getDaysInBetween(widget.currentDate!, widget.currentDate!.add(Duration(days: 6)));
              return  Container(
                height: 75*SizeConfig.heightMultiplier!,
                width: 46*SizeConfig.widthMultiplier!,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8*SizeConfig.widthMultiplier!),
                  color: (index == selectedIndex)?Color(0xff4FC24C):Colors.transparent,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8*SizeConfig.widthMultiplier!),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(new DateFormat("E").format(date[index]),style: GoogleFonts.openSans(
                          fontSize: (14) * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w600,
                          color: _getTextColor(selectedIndex, index),
                        ),),
                        SizedBox(
                          height: 7 * SizeConfig.heightMultiplier!,),
                        Text(date[index].day.toString(),style:GoogleFonts.openSans(
                          fontSize: (14) * SizeConfig.textMultiplier!,
                          fontWeight: FontWeight.w600,
                          color: _getTextColor(selectedIndex, index),
                        ) // Dat
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onChanged!(date[index]);
                  },
                ),
              );
            }
            ),

          ),

        ],
      ),
    );
  }

  Color _getTextColor(int selectedIndex,int index){
   if(index == selectedIndex){
     return Colors.white;
   }
   if(index == 5&&selectedIndex<5){
     return Color(0xff747474);
   }
   if(index == 6 && selectedIndex<6){
     return Color(0xffB7B7B7);
   }
   else{
      return Colors.black;
   }
  }
}

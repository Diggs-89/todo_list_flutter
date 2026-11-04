import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskInput extends StatefulWidget {
  final DateTime selectdDate;
  final void function(String title, DateTime date );




 @override
  State<TaskInput> createState() => _TaskInputState()
 }



 class _TaskInputState extends State<TaskInput>{
  final TextEditingController _controller =  TextEditingController();
  late DateTime _taskDate;

  @override
  void InitSate(){
    super.initState();
    _taskDate = dateOnly(widget.selectdDate);
  }

  @override
  void didUpdateWidget (TaskInput soldWidget){
    super.didUpdateWidget((oldWidget));
    if ((!isSameday(oldWidget.selectdDate, widget.selectdDate))){
      _taskDate = dateOnly(Widget.selectdDate);
    }
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async{
    final picked = await showDatePicker(
      context: context,
      initialDate: _taskDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(20100),
    );

    if(picked != null){
      setState(() {
        _taskDate = dateOnly(picked);
      });
    }
  }

  void _submit(){
    final Title = _controller.text.trim();

    
  }
 }
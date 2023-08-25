import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String _input ='';
  String _result ='';


  void _onButtonPressed(String buttonText){
    setState(() {
      if (buttonText== '='){
        _calculateResult();
      } else if (buttonText== 'C'){
        _input ='';
        _result ='';
      } else{
        _input += buttonText;
      }
    });
  }


  void _calculateResult(){
    try{
      final result = _evaluateExpression(_input);
      _result =result.toString();
    }catch (e){
      _result='Error';
    }
  }
  double _evaluateExpression(String expression){
    Parser parser = Parser();
    ContextModel contextModel = ContextModel();
    Expression exp =parser.parse(expression);
    return exp.evaluate(EvaluationType.REAL,contextModel);
  }

  void deleteLastDigit(){
    if (_input.isNotEmpty){
      setState(() {
        _input =_input.substring(0,_input.length - 1);
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*1,
              width: MediaQuery.of(context).size.width*1,
              child: Container(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white,Colors.blue.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1,0.9],
                      tileMode: TileMode.repeated,
                    )
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      // input ui
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          alignment: Alignment.bottomRight,
                          child: SelectableText(
                            _input,
                            style: TextStyle(fontSize: 26.0,color: Colors.blueGrey),
                          ),
                        ),
                      ),
                      // output ui
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          alignment: Alignment.bottomRight,
                          child: SelectableText(
                            _result,
                            style: TextStyle(fontSize: 36.0,color: Colors.blueGrey),
                          ),
                        ),
                      ),
                      Divider(height: 1.0,),
                      // output ui end
                      // edit button
                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.8,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: TextButton(
                                onPressed: (){
                                deleteLastDigit();
                                },
                                child: Text('Edit'
                                ,style: TextStyle(
                                    fontSize: 15.0,color: Colors.blueGrey,
                                  ),)
                              ),
                            )
                          ],
                        ),
                      ),
                      // edit button end
                      // input buttons ui
                      GridView.builder(
                        shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4) ,
                          itemBuilder:(BuildContext context, int index){
                          // we need to create button labels
                          final buttonText = _buttonLabels[index];
                          return  Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: TextButton(
                                onPressed: (){
                                 //button press function
                                  _onButtonPressed(buttonText);
                                },
                                child: Text( buttonText
                                  ,style: TextStyle(
                                    fontSize: 35.0,color: Colors.blueGrey,
                                  ),),
                            ),
                          );
                          },
                        itemCount: _buttonLabels.length,

                      )
                      // input buttons ui end

                      // input ui end
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final List<String> _buttonLabels =[
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '=',
    '+',
  ];
}

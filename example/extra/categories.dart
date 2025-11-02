import 'package:ico3_logger/ico3_logger.dart';

void main() {

  var tstA = Log.getAllCategories();
  print(tstA);
  Log.info('process', 'test process1');
  Log.setCategories('<clear> network(warning), process, core(critical)');
  var tst = Log.getAllCategories();
  print('categories -> $tst');
  Log.info('process', 'test process2');
  Log.setCategories(' networkx(warning), processx, corex(critical), -test, -option(error)');
  var tst1 = Log.getAllCategories();
  print('categories -> $tst1');


  Log.setCategories('<clear> all, -process');
  var tst2 = Log.getAllCategories();
  print('categories -> $tst2');
  Log.info('process', 'test process3');
  Log.info('xprocess', 'test xxprocess');
  Log.setCategories('<clear>');
  var tst3 = Log.getAllCategories();
  print('categories -> $tst3');
  Log.info('process', 'test process4');

}


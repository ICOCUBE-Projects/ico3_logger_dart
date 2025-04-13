import 'package:ico3_logger/ico3_logger.dart';

import 'package:test/test.dart';

void main() {
  test('Test base ICO3Log', () {
    Log.setCategories('network(warning), core, -core(error)', clear: true);
    var cList = Log.getAllCategories();
    print(cList);
    Log.info('network', 'testAAA network');
    Log.log('test', 'test test info');
    Log.critical('core', 'test core critical');
    Log.info('core', 'core test info');
    Log.fatal('core', 'core fatal rrrrrrrr');
    Log.setCategories('-core(none)');
    print(Log.getAllCategories());
    Log.critical('core', 'test core criticalxx');
    Log.info('core', 'core test infoxx');
    Log.fatal('core', 'core fatal rrrrrrrrxx');
    Log.setCategories('all, -core(error)', clear: true);
    Log.info('network', 'testAAA network');
    Log.log('test', 'test test info');
    Log.critical('core', 'test core critical');
    Log.info('core', 'core test info');
    Log.fatal('core', 'core fatal rrrrrrrr');
  });
}

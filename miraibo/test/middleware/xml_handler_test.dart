import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:miraibo/middleware/xml_handler.dart';

void main() {
  test('dump', () async {
    final xmlStreamController = StreamController<String>();
    final dumper = XmlDumper(xmlStreamController.sink);
    dumper.open('tag');
    dumper.close('tag');
    dumper.appendEnclosedContent('tag', 'content');
    dumper.open('tag');
    dumper.appendEnclosedContent('tag', 'content');
    dumper.appendContent('content');
    dumper.close('tag');
    dumper.done();
    Logger().i(await xmlStreamController.stream.toList());
  });
  test('parse', () async {
    final xmlStreamController = StreamController<String>();
    final dumper = XmlDumper(xmlStreamController.sink);
    dumper.open('tag');
    dumper.close('tag');
    dumper.appendEnclosedContent('tag', 'content' * 512);
    dumper.open('tag');
    dumper.appendEnclosedContent('tag', 'content');
    dumper.appendContent('content');
    dumper.close('tag');
    dumper.done();
    final parser = XmlParser(xmlStreamController.stream);
    Logger().i(await parser.getFragments().toList());
  });
}

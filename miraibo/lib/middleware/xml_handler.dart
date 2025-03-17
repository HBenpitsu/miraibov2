class XmlDumper {
  final Sink<String> dumpTo;
  XmlDumper(this.dumpTo);
  List<String> context = [];
  void done() {
    if (context.isNotEmpty) {
      throw StateError('some context is not resolved: $context');
    }
    dumpTo.close();
  }

  void open(String tag) {
    context.add(tag);
    dumpTo.add('<$tag>');
  }

  void appendContent(String content) {
    dumpTo.add(content);
  }

  void appendEnclosedContent(String tag, String content) {
    dumpTo.add('<$tag>$content</$tag>');
  }

  void close(String tag) {
    if (context.isEmpty) {
      throw StateError('no context to close: $tag');
    }
    if (context.last != tag) {
      throw StateError('context mismatch: $tag');
    }
    context.removeLast();
    dumpTo.add('</$tag>');
  }
}

class XmlParser {
  final Stream<String> loadFrom;
  XmlParser(this.loadFrom);

  final List<(List<String>, String)> _fragments = [];

  final List<String> _context = [];
  int _angleDepth = 0;
  static final int _bufferSize = 1024;
  final StringBuffer _buffer = StringBuffer();

  bool _isUsed = false;
  Stream<(List<String>, String)> getFragments() async* {
    if (_isUsed) {
      throw StateError('parser is already used');
    }
    _isUsed = true;
    await for (final chunk in loadFrom) {
      for (int i = 0; i < chunk.length; i++) {
        final char = chunk[i];
        if (_angleDepth > 0) {
          _addCharToTag(char);
        } else {
          _addCharToContent(char);
        }
      }
      for (final fragment in _fragments) {
        yield fragment;
      }
      _fragments.clear();
    }
  }

  _addCharToTag(String char) {
    if (char == '<') {
      _angleDepth += 1;
    } else if (char == '>') {
      _angleDepth -= 1;
      if (_angleDepth == 0) {
        _updateContext();
        return;
      }
    }
    _buffer.write(char);
  }

  _updateContext() {
    final tag = _buffer.toString();
    _buffer.clear();
    if (tag.startsWith('/')) {
      final closingTag = tag.substring(1);
      if (_context.isEmpty) {
        throw StateError('no context to close: $closingTag');
      }
      if (_context.last != closingTag) {
        throw StateError('context mismatch: $closingTag');
      }
      _context.removeLast();
    } else {
      _context.add(tag);
    }
  }

  _addCharToContent(String char) {
    if (char == '<') {
      _angleDepth = 1;
      _dumpBufferToFragment();
    } else {
      _buffer.write(char);
      if (_buffer.length > _bufferSize) {
        _dumpBufferToFragment();
      }
    }
  }

  _dumpBufferToFragment() {
    _fragments.add(([..._context], _buffer.toString()));
    _buffer.clear();
  }
}

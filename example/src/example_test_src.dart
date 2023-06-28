import 'package:source_gen_test_golden/annotations.dart';

import 'example_annotation.dart';

@ShouldGenerateFile(
  'example_test_golden.dart',
  partOfCurrent: true,
  configurations: ['default', 'no-prefix-required'],
)
@ExampleAnnotation()
class TestClassFilePartOfCurrent {}

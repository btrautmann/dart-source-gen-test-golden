import 'package:source_gen_test_golden/annotations.dart';

import 'test_annotation.dart';

part 'goldens/test_library_file_part_of_current.dart';

@ShouldGenerateFile(
  'goldens/test_library_file_no_part.dart',
  configurations: ['default', 'no-prefix-required'],
)
@TestAnnotation()
class TestClassFileNoPart {}

@ShouldGenerateFile(
  'goldens/test_library_file_part_of.dart',
  partOf: 'test_part_owner.dart',
  configurations: ['default', 'no-prefix-required'],
)
@TestAnnotation()
class TestClassFilePartOf {}

@ShouldGenerateFile(
  'goldens/test_library_file_part_of_current.dart',
  partOfCurrent: true,
  configurations: ['default', 'no-prefix-required'],
)
@TestAnnotation()
class TestClassFilePartOfCurrent {}

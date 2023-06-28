import 'package:source_gen_test_golden/src/build_log_tracking.dart';
import 'package:source_gen_test_golden/src/init_library_reader.dart';
import 'package:source_gen_test_golden/src/test_annotated_classes.dart';
import 'package:test/test.dart';

import 'test_generator.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'test_library.dart',
  );

  group('testAnnotatedElements', () {
    const validAdditionalGenerators = {
      'no-prefix-required': TestGenerator(requireTestClassPrefix: false),
    };

    const validExpectedAnnotatedTests = [
      'TestClassFileNoPart',
      'TestClassFilePartOf',
      'TestClassFilePartOfCurrent',
    ];

    group('[integration tests]', () {
      initializeBuildLogTracking();
      testAnnotatedElements(
        reader,
        const TestGenerator(),
        additionalGenerators: validAdditionalGenerators,
        expectedAnnotatedTests: validExpectedAnnotatedTests,
      );
    });

    group('test counts', () {
      test('nul defaultConfiguration', () {
        final list = getAnnotatedClasses(
          reader,
          const TestGenerator(),
          additionalGenerators: validAdditionalGenerators,
          expectedAnnotatedTests: validExpectedAnnotatedTests,
          defaultConfiguration: null,
        );

        expect(list, hasLength(6));
      });

      test('valid configuration', () {
        final list = getAnnotatedClasses(
          reader,
          const TestGenerator(),
          additionalGenerators: validAdditionalGenerators,
          expectedAnnotatedTests: validExpectedAnnotatedTests,
          defaultConfiguration: ['default', 'no-prefix-required'],
        );

        expect(list, hasLength(6));
      });

      test('different defaultConfiguration', () {
        final list = getAnnotatedClasses(
          reader,
          const TestGenerator(),
          additionalGenerators: validAdditionalGenerators,
          expectedAnnotatedTests: validExpectedAnnotatedTests,
          defaultConfiguration: ['default'],
        );

        expect(list, hasLength(6));
      });

      test('different defaultConfiguration', () {
        final list = getAnnotatedClasses(
          reader,
          const TestGenerator(),
          additionalGenerators: validAdditionalGenerators,
          expectedAnnotatedTests: validExpectedAnnotatedTests,
          defaultConfiguration: ['no-prefix-required'],
        );

        expect(list, hasLength(6));
      });
    });
    group('defaultConfiguration', () {
      test('empty', () {
        expect(
          () => testAnnotatedElements(
            reader,
            const TestGenerator(),
            additionalGenerators: validAdditionalGenerators,
            defaultConfiguration: [],
          ),
          _throwsArgumentError(
            'Cannot be empty.',
            'defaultConfiguration',
          ),
        );
      });

      test('unknown item', () {
        expect(
          () => testAnnotatedElements(
            reader,
            const TestGenerator(),
            additionalGenerators: const {
              'no-prefix-required':
                  TestGenerator(requireTestClassPrefix: false),
            },
            defaultConfiguration: ['unknown'],
          ),
          _throwsArgumentError(
            'Contains values not associated with provided generators: '
                '"unknown".',
            'defaultConfiguration',
          ),
        );
      });
    });

    group('expectedAnnotatedTests', () {
      test('too many', () {
        expect(
          () => testAnnotatedElements(
            reader,
            const TestGenerator(),
            expectedAnnotatedTests: [
              'TestClass1',
              'TestClass2',
              'BadTestClass',
              'extra',
            ],
          ),
          _throwsArgumentError(
            'There are unexpected items',
            'expectedAnnotatedTests',
          ),
        );
      });
    });

    group('additionalGenerators', () {
      test('unused generator fails', () {
        expect(
          () => testAnnotatedElements(
            reader,
            const TestGenerator(),
            additionalGenerators: {'extra': const TestGenerator()}
              ..addAll(validAdditionalGenerators),
            expectedAnnotatedTests: [
              'TestClass1',
              'TestClass2',
              'BadTestClass',
              'BadTestClass',
              'badTestFunc',
              'badTestFunc',
            ],
            // 'vague' is excluded here!
            defaultConfiguration: ['default', 'no-prefix-required'],
          ),
          _throwsArgumentError(
            'Some of the specified generators were not used for their '
            'corresponding configurations: "extra".\n'
            'Remove the entry from `additionalGenerators` or update '
            '`defaultConfiguration`.',
          ),
        );
      });

      test('key "default" not allowed', () {
        expect(
          () => testAnnotatedElements(
            reader,
            const TestGenerator(),
            additionalGenerators: const {
              'default': TestGenerator(requireTestClassPrefix: false),
            },
          ),
          _throwsArgumentError(
            'Contained an unsupported key "default".',
            'additionalGenerators',
          ),
        );
      });

      test('key "" not allowed', () {
        expect(
          () => testAnnotatedElements(
            reader,
            const TestGenerator(),
            additionalGenerators: const {
              '': TestGenerator(requireTestClassPrefix: false),
            },
          ),
          _throwsArgumentError(
            'Contained an unsupported key "".',
            'additionalGenerators',
          ),
        );
      });
    });
  });
}

Matcher _throwsArgumentError(Object? matcher, [String? name]) => throwsA(
      isArgumentError
          .having((e) => e.message, 'message', matcher)
          .having((ae) => ae.name, 'name', name),
    );

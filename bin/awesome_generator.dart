import 'dart:io';

import 'package:args/args.dart';
import 'package:awesome_generator/awesome_generator.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption(
    'token',
    valueHelp: 'token',
    defaultsTo: Platform.environment['GITHUB_TOKEN'],
    help: 'GitHub token (defaults to the GITHUB_TOKEN environment variable)',
  );
  parser.addOption(
    'output',
    abbr: 'o',
    valueHelp: 'path',
    help: 'The output path (defaults to stdout)',
  );
  parser.addOption(
    'template',
    valueHelp: 'path',
    defaultsTo: 'readme.tmpl',
    help: 'Path to readme.tmpl.',
  );

  final options = parser.parse(args);

  final client = AwesomeClient(token: options['token']);
  final entries = <AwesomeEntry>[];
  for (final file in options.rest) {
    entries.addAll(await client.load(file));
  }
  client.close();

  final generator = AwesomeGenerator(
    template: options['template'],
    entries: entries,
  );
  await generator.generate(options['output']);
}

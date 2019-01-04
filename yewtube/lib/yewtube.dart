import 'dart:async';
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_file_service/angel_file_service.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_jael/angel_jael.dart';
import 'package:angel_static/angel_static.dart';
import 'package:angel_validate/server.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'video.dart';

Future<void> configureServer(Angel app) async {
  // Load app configuration
  var fs = LocalFileSystem();
  await app.configure(configuration(fs));

  // Find our upload dir.
  var uploadPath = app.configuration['upload_dir'] as String;
  var uploadDir = fs.directory(uploadPath);

  // We'll use this to name files.
  var uuid = Uuid();

  // Enable Jael templates
  await app.configure(jael(fs.directory('views')));

  // Create a service that reads a JSON file @ db.json,
  // and map it to the Video class
  var service = JsonFileService(fs.file('db.json'))
      .map(VideoSerializer.fromMap, VideoSerializer.toMap);

  // The index page just lists videos
  app.get('/', (req, res) async {
    var videos = await service.index();
    await res.render('index', {'title': 'Videos', 'videos': videos});
  });

  // This page allows a user to watch a video.
  app.get('/watch/:id', (req, res) async {
    // Find the corresponding video.
    var id = req.params['id'] as String;
    var video = await service.read(id);

    // Resolve the public path to the video file.
    var publicPath = p.relative(
      p.join(uploadPath, video.filePath),
      from: 'web',
    );

    // Render the page.
    await res.render('watch', {
      'title': video.title,
      'video': video,
      'publicPath': '/$publicPath',
    });
  });

  // Upload form + backend
  app.get('/upload', (req, res) => res.render('upload', {'title': 'Upload'}));

  // Use a validator to ensure there's a title, etc.
  app.post(
    '/upload',
    chain([
      validate(Validator({
        requireFields(['title', 'description']): isNonEmptyString,
      })),
      (req, res) async {
        // Find the first file the user uploaded.
        var file = req.uploadedFiles.firstWhere(
            (v) => v.contentType.type == 'video',
            orElse: () => null);

        if (file == null) {
          throw AngelHttpException.badRequest(message: 'Missing video file.');
        }

        // Fetch the validated data from the body
        var title = req.bodyAsMap['title'] as String;
        var description = req.bodyAsMap['description'] as String;

        // Assume that for a video of type video/x, the extension is .x
        var filePath =
            p.setExtension(uuid.v4(), '.${file.contentType.subtype}');

        // Pipe the video into the corresponding file.
        var videoFile = uploadDir.childFile(filePath);
        await file.data.pipe(videoFile.openWrite());

        // Create a new video.
        var stamp = DateTime.now();
        var video = Video(
          title: title,
          description: description,
          filePath: filePath,
          mimeType: file.contentType.mimeType,
          createdAt: stamp,
          updatedAt: stamp,
        );

        // Insert it into the "database"
        video = await service.create(video);

        // Redirect to the watch page
        res.redirect('/watch/${video.id}');
      },
    ]),
  );

  var oldErrorHandler = app.errorHandler;
  app.errorHandler = (e, req, res) {
    if (req.accepts('text/html', strict: true)) {
      return res.render(
          'error', {'title': 'Error ${e.statusCode}', 'error': e.message});
    } else {
      return oldErrorHandler(e, req, res);
    }
  };

  // Static file server
  var vDir = VirtualDirectory(app, fs, source: fs.directory('web'));
  app.fallback(vDir.handleRequest);

  // Throw a 404 when page is not found
  app.fallback((req, res) => throw AngelHttpException.notFound());
}

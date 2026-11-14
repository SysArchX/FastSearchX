// FastSearchX smoke tests: validate constants and download helpers
// without instantiating the WebView (which requires a native platform).

import 'package:flutter_test/flutter_test.dart';
import 'package:fastsearchx_app/main.dart';

void main() {
  test('FastSearchX: download folders and credits', () {
    expect(AppPaths.base, '/storage/emulated/0/Download/FastSearchX');
    expect(AppPaths.videos, '${AppPaths.base}/FastSearchX_videos');
    expect(AppPaths.music, '${AppPaths.base}/FastSearchX_music');
    expect(kGitHubUrl, 'https://github.com/SysArchX/FastSearchX');
    expect(kHomeUrl, 'https://www.google.com');
    expect(kAppVersion, '1.3.0');
  });

  test('separates video, audio and regular files into different folders', () {
    expect(AppPaths.folderFor(isVideo: true, isAudio: false), AppPaths.videos);
    expect(AppPaths.folderFor(isVideo: false, isAudio: true), AppPaths.music);
    expect(AppPaths.folderFor(isVideo: false, isAudio: false), AppPaths.base);
    expect(AppPaths.folderForName('filme.mp4'), AppPaths.videos);
    expect(AppPaths.folderForName('musica.mp3'), AppPaths.music);
    expect(AppPaths.folderForName('documento.pdf'), AppPaths.base);
  });

  test('recognises media and HLS/DASH streams', () {
    expect(isMediaUrl('https://example.com/video.mp4'), isTrue);
    expect(isMediaUrl('https://example.com/music.mp3'), isTrue);
    expect(isMediaUrl('https://example.com/playlist.m3u8'), isTrue);
    expect(isMediaUrl('https://example.com/manifest.mpd'), isTrue);
    expect(isMediaUrl('https://example.com/file.zip'), isFalse);
    expect(isStreamingMediaUrl('https://example.com/live.m3u8'), isTrue);
    expect(isStreamingMediaUrl('https://example.com/video.mp4'), isFalse);
  });

  test('detects links that should be downloaded', () {
    expect(looksLikeDownloadUrl('https://example.com/file.zip'), isTrue);
    expect(looksLikeDownloadUrl('https://example.com/foto.JPG'), isTrue);
    expect(looksLikeDownloadUrl('https://youtube.com/watch?v=abc123'), isFalse);
    expect(looksLikeDownloadUrl('https://example.com/page'), isFalse);
  });

  test('extracts the file name from Content-Disposition', () {
    expect(
      fileNameFromDisposition('attachment; filename="foto.jpg"'),
      'foto.jpg',
    );
    expect(
      fileNameFromDisposition("attachment; filename*=UTF-8''my%20video.mp4"),
      'my video.mp4',
    );
    expect(fileNameFromDisposition(null), isNull);
  });

  test('infers the extension from the MIME type', () {
    expect(extensionForMime('video/mp4'), 'mp4');
    expect(extensionForMime('audio/mpeg; charset=binary'), 'mp3');
    expect(extensionForMime('application/pdf'), 'pdf');
    expect(extensionForMime('desconhecido/x'), isNull);
  });

  test('sanitizes and formats names', () {
    expect(sanitizeFileName('a/b:c*?.zip'), 'a_b_c__.zip');
    expect(sanitizeFileName('   '), 'file');
    expect(formatBytes(1024), '1.0 KB');
  });
}

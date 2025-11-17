// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void protectWebPage() {
  html.document.onContextMenu.listen((e) => e.preventDefault());
  html.document.onKeyDown.listen((e) {
    if (e.ctrlKey && e.key == "p") e.preventDefault();
  });
}

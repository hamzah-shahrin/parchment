import 'package:get_it/get_it.dart';
import 'package:parchment/views/all_links_view.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerFactory<LinksViewModel>(() => LinksViewModel());
}
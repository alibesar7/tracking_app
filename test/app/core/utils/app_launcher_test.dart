import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tracking_app/app/core/utils/app_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'app_launcher_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UrlLauncherPlatform>(mixingIn: [MockPlatformInterfaceMixin]),
])
void main() {
  late MockUrlLauncherPlatform mockPlatform;

  setUp(() {
    mockPlatform = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockPlatform;
  });

  group('AppLauncher Tests', () {
    test('launchPhone should call launchUrl with tel scheme', () async {
      const phoneNumber = '0123456789';
      const expectedUrl = 'tel:0123456789';

      when(mockPlatform.canLaunch(expectedUrl)).thenAnswer((_) async => true);
      when(
        mockPlatform.launchUrl(expectedUrl, any),
      ).thenAnswer((_) async => true);

      AppLauncher.launchPhone(phoneNumber);

      await untilCalled(mockPlatform.launchUrl(expectedUrl, any));

      verify(mockPlatform.launchUrl(expectedUrl, any)).called(1);
    });

    test(
      'launchWhatsApp should format Egyptian numbers correctly and launch',
      () async {
        const phoneNumber = '01012345678';
        const expectedUrl = 'whatsapp://send?phone=201012345678';

        when(
          mockPlatform.launchUrl(expectedUrl, any),
        ).thenAnswer((_) async => true);

        AppLauncher.launchWhatsApp(phoneNumber);

        await untilCalled(mockPlatform.launchUrl(expectedUrl, any));

        verify(mockPlatform.launchUrl(expectedUrl, any)).called(1);
      },
    );

    test('launchWhatsApp should strip non-numeric characters', () async {
      const phoneNumber = '+20 (123) 456-789';
      const expectedUrl = 'whatsapp://send?phone=20123456789';

      when(
        mockPlatform.launchUrl(expectedUrl, any),
      ).thenAnswer((_) async => true);

      AppLauncher.launchWhatsApp(phoneNumber);
      await untilCalled(mockPlatform.launchUrl(expectedUrl, any));

      verify(mockPlatform.launchUrl(expectedUrl, any)).called(1);
    });
  });
}

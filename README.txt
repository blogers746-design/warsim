WarSim (Godot 4.3+). Сборка APK:
1. Установи Godot 4.3+ (не .NET), JDK 17, Android SDK (cmdline-tools + platform-tools + build-tools 34).
2. Godot: Editor > Editor Settings > Export > Android: укажи пути к SDK и JDK.
3. Project > Import > выбери папку/project.godot.
4. Editor > Manage Export Templates > Download and Install.
5. Project > Export > Add > Android, включи Use Gradle Build выключенным (по умолчанию), Export Project > .apk.
Управление: левая часть экрана - движение, правая - обзор, кнопки справа. ДРОН - переключить, БОМБА - сбросить с дрона.
Тест на ПК: стрелки - движение.

СБОРКА ЧЕРЕЗ GITHUB:
1. Создай репозиторий на github.com, залей в него содержимое этой папки (project.godot должен лежать в корне, вместе с папкой .github).
2. Вкладка Actions > Build Android APK > Run workflow (или просто сделай push).
3. Через 5-10 минут открой завершённый запуск, внизу в Artifacts скачай warsim-apk (внутри warsim.apk).

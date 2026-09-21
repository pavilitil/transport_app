# 🚌 Транспортний навігатор (Transport Navigator)

**Лабораторна робота №5 з дисципліни «Сучасні технології проєктування»**  
**Варіант №25:** Транспортний навігатор

Застосунок для пошуку та перегляду оптимальних маршрутів громадського транспорту, розроблений на фреймворку **Flutter** із чітким дотриманням принципів **Clean Architecture** (Чиста архітектура) та інверсії залежностей (DIP).

---

## 🏗️ Архітектура проєкту (Clean Architecture)

Проєкт розділений на 4 повністю незалежні шари:

* **Domain Layer (Домен):** Включає бізнес-сутність `RouteEntity` та абстрактний інтерфейс `ITransportRepository`. Шар абсолютно незалежний від фреймворків, бази даних чи UI.
* **Application Layer (Застосунок):** Містить сценарій використання `SearchRoutesUseCase`, який відповідає за бізнес-логіку перевірки та пошуку маршрутів.
* **Infrastructure Layer (Інфраструктура):** Реалізує доменний інтерфейс у виглядi `JsonTransportRepository` для отримання даних про транспортування.
* **Presentation Layer (Представлення):** Графічний інтерфейс користувача (UI) на Flutter та управління станом із використанням паттерна `ChangeNotifier` та пакету `provider` (`RouteNotifier`).

### Схема залежностей шарів

```text
[ Presentation Layer (UI & State) ]
               │
               ▼
 [ Application Layer (Use Cases) ]
               │
               ▼
    [ Domain Layer (Entities & Repositories) ]
               ▲
               │ (реалізує)
[ Infrastructure Layer (Data Sources) ]
📁 Структура каталогів
Plaintext
lib/
├── domain/                         # Шар бізнес-правил та сутностей
│   ├── entities/
│   │   └── route_entity.dart
│   └── repositories/
│       └── i_transport_repository.dart
├── application/                    # Шар сценаріїв використання (Use Cases)
│   └── usecases/
│       └── search_routes_usecase.dart
├── infrastructure/                 # Шар роботи з даними (БД, JSON, API)
│   └── repositories/
│       └── json_transport_repository.dart
└── presentation/                   # Шар користувацького інтерфейсу та стану
    ├── state/
    │   └── route_notifier.dart
    └── ui/
        └── main.dart
🚀 Інструкція із запуску проєкту
Передумови
Встановлений Flutter SDK (версія 3.x або новіша).

Встановлений браузер Google Chrome (для швидкого запуску).

Кроки для запуску
Клонуйте репозиторій:

Bash
git clone [https://github.com/ВАШ_НІКНЕЙМ/transport_app.git](https://github.com/ВАШ_НІКНЕЙМ/transport_app.git)
cd transport_app
Завантажте необхідні залежності:

Bash
flutter pub get
Запустіть застосунок у Chrome:

Bash
flutter run -d chrome
🛠️ Використані технології
Мова розробки: Dart

Фреймворк: Flutter

Менеджмент стану: provider

Система версіонування: Git (модель гілкування Git Flow, специфікація Conventional Commits)
# Integración en Xcode

## 1. Crear el proyecto
1. Xcode → **File → New → Project → iOS → App**.
2. Nombre: `AhorroCompartido`. Interface: **SwiftUI**. Language: **Swift**. Sin Core Data ni Tests (no son necesarios).
3. Guardalo donde quieras; luego vas a **reemplazar** su contenido con esta carpeta.

## 2. Copiar los archivos
Xcode ya crea `AhorroCompartidoApp.swift` y `ContentView.swift` por defecto — **borralos** del proyecto (Move to Trash) y arrastrá estas carpetas completas desde Finder al navegador de Xcode, respetando esta estructura de grupos (carpetas amarillas):

```
AhorroCompartido/
├── App/                → AhorroCompartidoApp.swift
├── Models/              → AppThemeMode, IncomeFrequency, Envelope, SavingsGoal, PartnerLink, SharedLocation
├── ViewModels/           → ThemeViewModel, BudgetViewModel, SavingsViewModel, PairingViewModel, LocationViewModel
├── Views/                → RootTabView, HomeView, RegisterIncomeView, EnvelopeDetailView, SavingsView,
│                           AddSavingsGoalView, SavingsGoalDetailView, MapView, PairingView, SettingsView
│   └── Components/       → EnvelopeCardView, ProgressBarView, CardBackground, SavingsHistoryChartView
└── Helpers/              → CurrencyFormatter, PersistenceStore, SharedBackendService, NotificationManager
```

Al arrastrar, marcá **"Copy items if needed"** y asegurate de que el checkbox del target `AhorroCompartido` esté tildado en "Add to targets".

## 3. Frameworks
Todos son frameworks de sistema, no hace falta agregar dependencias externas:
`SwiftUI`, `Combine`, `CoreLocation`, `MapKit`, `Charts` (iOS 16+), `UserNotifications`.

**Deployment Target recomendado: iOS 17.0** (usa `Map(position:)` de MapKit y `onChange(of:)` con dos parámetros, ambos de iOS 17).

## 4. Info.plist — permisos obligatorios
En el target → **Info** → agregar:

| Key | Valor sugerido |
|---|---|
| `NSLocationWhenInUseUsageDescription` | "Usamos tu ubicación para mostrársela a tu pareja vinculada." |
| `NSLocationAlwaysAndWhenInUseUsageDescription` | "Necesitamos tu ubicación en segundo plano para avisarte cuando estés cerca de una zona comercial." |
| `NSUserNotificationsUsageDescription` (opcional, iOS la pide vía API, no plist) | — |

## 5. Capabilities (target → Signing & Capabilities)
- **Background Modes** → tildar **Location updates** (necesario para el geofence de `scheduleCommercialZoneReminder` y para publicar ubicación en segundo plano).
- **Push Notifications** no es necesario para las notificaciones locales (`UNUserNotificationCenter`) usadas en este código.

## 6. Firebase (opcional, para backend real)
Ahora mismo `MockSharedBackendService` simula el vínculo, la ubicación y los aportes compartidos **en memoria dentro del mismo proceso** (útil para probar la UI en un solo dispositivo/simulador). Para que dos teléfonos reales se vean entre sí:

1. Agregá el SDK de Firebase vía Swift Package Manager: `https://github.com/firebase/firebase-ios-sdk`, módulo `FirebaseDatabase`.
2. Creá `FirebaseSharedBackendService: SharedBackendService` en `Helpers/`, implementando los mismos métodos del protocolo pero escribiendo/leyendo de Realtime Database en las rutas documentadas como comentario en `SharedBackendService.swift` (`/links/{code}`, `/locations/{code}`, `/sharedSavings/{code}/events`).
3. En `AhorroCompartidoApp.swift`, cambiá las inyecciones de `MockSharedBackendService.shared` por tu nueva clase en `PairingViewModel`, `LocationViewModel` y `SavingsViewModel` (los tres aceptan `backend:` en su `init`).

No se necesita tocar ninguna vista: todas dependen del protocolo, no de la implementación.

## 7. Primer build
1. Elegí un simulador de iPhone (iOS 17+).
2. Cmd+R. La app abre en la pestaña **Inicio** con los 5 sobres por defecto en $0.
3. Tocá el botón **+** para "Registrar Cobro" y confirmá que la distribución por porcentaje se refleje en las tarjetas.
4. En **Ajustes** probá cambiar de tema y editar los porcentajes (deben sumar 100%).
5. En **Mapa**, aceptá el permiso de ubicación; sin vincular todavía vas a ver la pantalla de **Vinculación** con tu código tipo `AHORRO-1234`.
6. En **Ahorros**, creá una meta y aportale dinero para ver la barra de progreso y el gráfico de evolución.

## Notas de diseño
- El envelope `remainingFraction` representa lo que queda disponible del ciclo actual (se resetea sumando en cada `registerIncome`, nunca se resetea a cero salvo que gastes todo). Si preferís que cada cobro reinicie el ciclo completo (en vez de acumular), poné `allocatedThisCycle = share` en lugar de `+= share` dentro de `BudgetViewModel.registerIncome`.
- La vinculación por código (`PairingViewModel`) y el mock de backend viven en memoria del proceso: perfecto para demo/desarrollo, pero para producción real necesitás el paso 6.

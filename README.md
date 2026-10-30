<div align="center">

# 💸 Ahorro Compartido

**App iOS de ahorro en pareja: presupuesto por sobres, metas de ahorro y ubicación compartida.**

![Swift](https://img.shields.io/badge/Swift-5-F05138?style=flat-square&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS_17+-0A84FF?style=flat-square&logo=swift&logoColor=white)
![MVVM](https://img.shields.io/badge/arquitectura-MVVM-8B5CF6?style=flat-square)

</div>

## Qué resuelve

Organizar el dinero de a dos suele terminar en planillas y mensajes. Ahorro Compartido reúne en una app el método de **sobres** (cada categoría con su monto asignado), las **metas de ahorro** y la posibilidad de **vincularse con la pareja**.

## Funcionalidades

- 💰 **Registro de ingresos** con distintas frecuencias.
- ✉️ **Presupuesto por sobres**, con detalle y barra de progreso por sobre.
- 🎯 **Metas de ahorro** con historial y gráfico de evolución.
- 👫 **Vinculación de pareja** y **ubicación compartida** en mapa.
- 🔔 **Notificaciones** locales.
- 🌗 **Tema claro / oscuro** configurable.
- 💾 Persistencia local de los datos.

## Arquitectura

Patrón **MVVM** en SwiftUI:

```
App/          punto de entrada
Models/       Envelope, SavingsGoal, PartnerLink, SharedLocation, IncomeFrequency, AppThemeMode
ViewModels/   Budget, Savings, Pairing, Location, Theme
Views/        pantallas y Components/ reutilizables
Helpers/      formato de moneda, persistencia, notificaciones, servicio de backend compartido
```

## Cómo correrlo

Necesitás **Xcode** y iOS 17 o superior.

1. Seguí la guía de [integración en Xcode](README_INTEGRACION_XCODE.md), o
2. generá el proyecto con [XcodeGen](https://github.com/yonaskolb/XcodeGen) a partir de `project.yml`:

```bash
brew install xcodegen
xcodegen generate
open AhorroCompartido.xcodeproj
```

## Autora

**Carolina Lobo** · [LinkedIn](https://www.linkedin.com/in/carolina-lobo-469705297) · lobocarolina99@gmail.com

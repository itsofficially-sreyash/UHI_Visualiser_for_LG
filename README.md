<div align="center">

<pre>
██╗   ██╗██╗  ██╗██╗    ██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗     ██╗███████╗███████╗██████╗
██║   ██║██║  ██║██║    ██║   ██║██║██╔════╝██║   ██║██╔══██╗██║     ██║╚══███╔╝██╔════╝██╔══██╗
██║   ██║███████║██║    ██║   ██║██║███████╗██║   ██║███████║██║     ██║  ███╔╝ █████╗  ██████╔╝
██║   ██║██╔══██║██║    ╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║     ██║ ███╔╝  ██╔══╝  ██╔══██╗
╚██████╔╝██║  ██║██║     ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗██║███████╗███████╗██║  ██║
 ╚═════╝ ╚═╝  ╚═╝╚═╝      ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝
</pre>

**India's urban heat crisis — visualized across Liquid Galaxy screens.**<br/>
*Tap a city. Watch the heat. Hear the story.*

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Gemini](https://img.shields.io/badge/Gemini_API-1.5_Flash-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev)
[![Android](https://img.shields.io/badge/Android-API%2021+-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![License](https://img.shields.io/badge/License-MIT-8A2BE2?style=for-the-badge)](LICENSE)

<br/>

[![SSH](https://img.shields.io/badge/SSH-dartssh2-4A90D9?style=flat-square&logo=gnubash&logoColor=white)](https://pub.dev/packages/dartssh2)
[![KML](https://img.shields.io/badge/Visualization-KML_Polygons-34A853?style=flat-square&logo=googlemaps&logoColor=white)](https://developers.google.com/kml)
[![TTS](https://img.shields.io/badge/Narration-flutter__tts-FF6D00?style=flat-square)](https://pub.dev/packages/flutter_tts)
[![State](https://img.shields.io/badge/State-Provider-00B4D8?style=flat-square)](https://pub.dev/packages/provider)
[![GESOC](https://img.shields.io/badge/GESOC-2026-FF4500?style=flat-square)](https://www.liquidgalaxy.eu)

<br/>

<table>
<tr>
<td align="center"><b>5</b><br/><sub>Indian Cities</sub></td>
<td align="center"><b>4</b><br/><sub>Heat Zones / City</sub></td>
<td align="center"><b>3</b><br/><sub>LG Screens</sub></td>
<td align="center"><b>1</b><br/><sub>Gemini Narrator</sub></td>
<td align="center"><b>0</b><br/><sub>Plaintext Secrets</sub></td>
</tr>
</table>

</div>

<br/>

---

## What is UHI Visualizer?

[**Liquid Galaxy**](https://www.liquidgalaxy.eu/) is an open-source panoramic display platform — multiple Linux machines running Google Earth in perfect sync across a curved wall of screens. Built for impact. Built for storytelling.

**UHI Visualizer** brings India's silent climate crisis to those screens.

The Urban Heat Island effect makes Indian city cores 3-7°C hotter than their surroundings — a consequence of concrete replacing green cover at scale. Delhi, Mumbai, Pune, Bangalore, Chennai are all affected. The satellite data exists. But nobody has visualized it at this scale, with this kind of narrative layer.

- **Tap a city** — Flutter app sends a KML heatmap to the LG rig via SSH
- **Watch the heat** — concentric thermal zones render across all LG screens on Google Earth
- **Hear the story** — Gemini AI narrates that city's specific heat situation using real climate context, delivered via text-to-speech

> The goal: make climate data feel human. Not a chart. A story on a wall of screens.

<br/>

---

## App Preview

<div align="center">

*Dark theme · Climate dashboard aesthetic · Android controller*

</div>

```
╔═══════════════════════════════════════════╗   ╔═══════════════════════════════════════════╗
║  UHI VISUALIZER          ● LG Live        ║   ║  Delhi — Heat Story              [Stop]   ║
║  India Heat                               ║   ╠═══════════════════════════════════════════╣
║  Island Map                               ║   ║                                           ║
╠═══════════════════════════════════════════╣   ║  Delhi's urban core sits nearly 7°C above ║
║  Select a city to visualize heat patterns ║   ║  its outskirts — one of the most severe   ║
║                                           ║   ║  heat islands on the planet. Decades of   ║
║  ┌─────────────────────────────────────┐  ║   ║  rapid concrete expansion have eliminated ║
║  │ 🔥  Delhi                    +7°C ▶ │  ║   ║  the green buffers that once kept the     ║
║  │     Severe — dense concrete core    │  ║   ║  city breathable. On peak summer days,    ║
║  └─────────────────────────────────────┘  ║   ║  surface temps exceed 55°C — a direct     ║
║  ┌─────────────────────────────────────┐  ║   ║  threat to millions of residents.         ║
║  │ 🌆  Mumbai                   +5°C  │  ║   ║                                           ║
║  │     Coastal heat trap                │  ║   ║  📍 /Documents/uhi_Delhi.kml             ║
║  └─────────────────────────────────────┘  ║   ╚═══════════════════════════════════════════╝
║  ┌─────────────────────────────────────┐  ║
║  │ ☀️  Pune                     +4°C  │  ║
║  │     Moderate — rapid urbanization   │  ║
║  └─────────────────────────────────────┘  ║
║  ┌─────────────────────────────────────┐  ║
║  │ 🌿  Bangalore                +3°C  │  ║
║  │     Rising — green cover declining  │  ║
║  └─────────────────────────────────────┘  ║
║  ┌─────────────────────────────────────┐  ║
║  │ 🏙️  Chennai                  +6°C  │  ║
║  │     High humidity heat mix          │  ║
║  └─────────────────────────────────────┘  ║
╚═══════════════════════════════════════════╝
```

**Liquid Galaxy — 3 screen heatmap render:**
```
╔══════════════╗  ╔══════════════════════════╗  ╔══════════════╗
║   [Screen 2] ║  ║       [Screen 1]         ║  ║   [Screen 3] ║
║              ║  ║   Delhi Heatmap          ║  ║              ║
║   ░░▒▒▓▓██  ║  ║  ██▓▓▒▒░░    ░░▒▒▓▓██  ║  ║  ██▓▓▒▒░░    ║
║   ░░▒▒▓▓██  ║  ║  ██▓▓▒▒░░    ░░▒▒▓▓██  ║  ║  ██▓▓▒▒░░    ║
║  [Hot→Cool] ║  ║     🔴 Hot Core City     ║  ║ [Hot→Cool]  ║
╚══════════════╝  ╚══════════════════════════╝  ╚══════════════╝
```

<br/>

---

## Roadmap

<div align="center">

`Progress ████████░░░░░░░░░░░░░░░░░░░░░░░░  Month 1 of 3  (June in progress)`

</div>

<br/>

| | Month | Focus | Deliverables |
|:---:|:---:|:---|:---|
| ✅ | **June** | **Core Pipeline** | Flutter app · SSH to LG · KML heatmap generation · Gemini narration · TTS · Virtual LG cluster (3 VMs) · Google Earth rendering confirmed |
| 🔄 | **July** | **Data + Polish** | MODIS satellite data integration · real temperature variance per city · UI polish · camera FlyTo · expand to 10 cities |
| 🔜 | **August** | **Demo + Docs** | Real LG rig testing · YouTube demo · full documentation · open source release |

<br/>

---

## Project Structure

```
uhi_visualizer/
│
├── lib/
│   ├── main.dart                        ← App entry, Provider setup
│   ├── models/
│   │   └── city.dart                    ← City model + kCities list (5 Indian cities)
│   ├── services/
│   │   ├── kml_service.dart             ← KML generator (4-zone concentric circles)
│   │   ├── gemini_service.dart          ← Gemini 1.5 Flash API narration
│   │   ├── tts_service.dart             ← flutter_tts voice narration
│   │   └── lg_service.dart              ← dartssh2 SSH: connect, sendKML, flyTo, clear
│   ├── providers/
│   │   └── city_provider.dart           ← ChangeNotifier: state + orchestration
│   └── screens/
│       └── city_list_screen.dart        ← Main UI: city list + narration panel
│
└── test/
    └── widget_test.dart
```

<br/>

---

## Tech Stack

<div align="center">

| Layer | Technology | What it does |
|:---:|:---:|:---|
| ![Flutter](https://img.shields.io/badge/-Flutter-02569B?logo=flutter&logoColor=white) | **Flutter 3.x + Dart 3.x** | Cross-platform mobile controller app |
| ![SSH](https://img.shields.io/badge/-dartssh2-4A90D9?logo=gnubash&logoColor=white) | **dartssh2 ^4.0** | Pure-Dart SSH2 — connects Flutter to LG master node |
| ![KML](https://img.shields.io/badge/-KML-34A853?logo=googlemaps&logoColor=white) | **Custom KML Builder** | Generates concentric circle heatmap polygons per city |
| ![Gemini](https://img.shields.io/badge/-Gemini_API-4285F4?logo=google&logoColor=white) | **Gemini 1.5 Flash** | City-specific heat story generation with climate context |
| ![TTS](https://img.shields.io/badge/-flutter__tts-FF6D00) | **flutter_tts ^4.0** | Voice narration — speaks Gemini's heat story aloud |
| ![State](https://img.shields.io/badge/-Provider-00B4D8) | **Provider ^6.1** | Reactive state management |
| ![Data](https://img.shields.io/badge/-MODIS_LST-0F9D58?logo=nasa&logoColor=white) | **Google Earth Engine** | *(July+)* MODIS Land Surface Temperature satellite data |

</div>

<br/>

---

## Getting Started

### Prerequisites

```
Flutter >= 3.16            flutter pub get     ✓
Android device / emulator                      ✓
LG rig or virtual cluster  SSH port 22 open    ✓
Gemini API key             aistudio.google.com ✓
```

### Install & Run

```bash
git clone https://github.com/itsofficially-sreyash/uhi_visualizer.git
cd uhi_visualizer
flutter pub get
flutter run          # Android device
flutter run -d linux # Linux desktop
```

### First Launch

```
1. App opens with 5 Indian cities listed
2. Tap any city (e.g. Pune)
        SSH connects to LG master
        KML heatmap generated and pushed to /var/www/html/kml/master.kml
        Google Earth renders 4-zone concentric heatmap
        Gemini generates city heat story
        TTS narrates it automatically
3. Tap another city to switch visualization
```

### LG Connection Setup

Update in `lib/providers/city_provider.dart`:

```dart
LGService(
  host: 'YOUR_LG_MASTER_IP',
  port: 22,
  username: 'lg',
  password: 'your_password',
)
```

### Virtual LG Cluster (local testing)

No physical rig? Set up a 3-VM virtual cluster:

```
1. Install VirtualBox
2. Create 3 Ubuntu VMs — LG1 (master, 2GB RAM), LG2 + LG3 (slaves, 1.5GB each)
3. Follow: https://youtu.be/CLdUuDHo6lU
4. Point app to LG1 master IP
```

<br/>

---

## How It Works

```
┌─────────────────┐     SSH (dartssh2)      ┌──────────────────────┐
│   Flutter App   │ ──────────────────────► │   LG Master Node     │
│  (Android/Linux)│                         │  /var/www/html/kml/  │
└─────────────────┘                         └──────────┬───────────┘
        │                                              │ NetworkLink
        │ Gemini API                                   ▼
        ▼                                   ┌──────────────────────┐
┌─────────────────┐                         │   Google Earth       │
│  Heat Story     │                         │  Heatmap renders on  │
│  (text + TTS)   │                         │  all LG screens      │
└─────────────────┘                         └──────────────────────┘
```

**KML Heatmap Structure (per city):**
```
🔴 Hot Core      (0.06° radius) — city center, peak temperature
🟠 Warm Zone     (0.12° radius) — inner suburbs
🟣 Moderate Zone (0.19° radius) — outer suburbs
🟢 Cool Ring     (0.28° radius) — rural edge, baseline temp
```

<br/>

---

## Contributing

```bash
git checkout -b feat/your-feature
# make changes
flutter analyze    # No issues found
flutter test       # All tests passed
# open PR → main
```

New cities go in `lib/models/city.dart` → `kCities` list.
New data sources go in `lib/services/kml_service.dart`.
LG commands go in `lib/services/lg_service.dart`.

<br/>

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

<br/>

---

<div align="center">

**Built with Flutter · dartssh2 · Gemini API · flutter_tts · Google Earth Engine**

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-blue?logo=flutter&logoColor=white)](https://flutter.dev)
&nbsp;
[![Gemini](https://img.shields.io/badge/Gemini_API-4285F4?logo=google&logoColor=white)](https://ai.google.dev)
&nbsp;
[![dartssh2](https://img.shields.io/badge/dartssh2-pub.dev-4A90D9)](https://pub.dev/packages/dartssh2)
&nbsp;
[![LiquidGalaxy](https://img.shields.io/badge/Liquid_Galaxy-GESOC_2026-FF4500)](https://www.liquidgalaxy.eu)

<br/>

*Liquid Galaxy is an open-source project by the Liquid Galaxy community.*
*UHI Visualizer is an independent GESOC 2026 contribution.*

</div>

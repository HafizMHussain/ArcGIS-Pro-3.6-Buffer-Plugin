# 🗺️ Buffer Tool Plugin for ArcGIS Pro 3.6

[![ArcGIS Pro](https://img.shields.io/badge/ArcGIS%20Pro-3.6-blue.svg)](https://www.esri.com/en-us/arcgis/products/arcgis-pro/)
[![.NET](https://img.shields.io/badge/.NET-8.0-purple.svg)](https://dotnet.microsoft.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A professional ArcGIS Pro add-in that provides advanced buffer analysis tools with both interactive mapping and batch processing capabilities. Built with the ArcGIS Pro SDK for .NET 8.0, this plugin seamlessly integrates into the ArcGIS Pro ribbon interface.

## ✨ Features

- **🖱️ Interactive Buffer Tool**: Click anywhere on the map to create instant buffers at the map center
- **📊 Batch Buffer Processing**: Create buffers around all features in a selected layer at once
- **💾 Smart Output Management**: Automatic saving to project geodatabase with timestamped names
- **⚡ Progress Reporting**: Real-time visual feedback during buffer operations
- **🎨 Professional UI**: Custom ribbon tab with intuitive icons and tooltips
- **🔧 Customizable**: Easy-to-modify buffer distances and parameters

## Prerequisites

### Required Software
- **ArcGIS Pro 3.6** (or compatible version)
- **Visual Studio 2022** (v17.13 or higher) - Community, Professional, or Enterprise
- **.NET 8.0 SDK** - [Download here](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
- **ArcGIS Pro SDK for .NET** - Install via Visual Studio Extensions

### Installing ArcGIS Pro SDK

1. Open Visual Studio 2022
2. Go to **Extensions** → **Manage Extensions**
3. Search for "ArcGIS Pro SDK"
4. Install the following extensions:
   - **ArcGIS Pro SDK for .NET** (Templates)
   - **ArcGIS Pro SDK Utilities** (Optional but recommended)
5. Restart Visual Studio

Alternatively, download directly from:
- [ArcGIS Pro SDK for .NET](https://github.com/Esri/arcgis-pro-sdk/releases)

## Project Structure

```
BufferToolPlugin/
├── BufferToolPlugin.csproj    # Project configuration
├── Config.daml                # UI definitions (tabs, buttons, tools)
├── Module1.cs                 # Main module class
├── BufferTool.cs              # Interactive map tool
├── BufferButton.cs            # Batch buffer button
├── Images/                    # Icon resources
│   ├── BufferTool16.png       # 16x16 icon for interactive tool
│   ├── BufferTool32.png       # 32x32 icon for interactive tool
│   ├── BufferButton16.png     # 16x16 icon for button
│   ├── BufferButton32.png     # 32x32 icon for button
│   └── AddinDesktop32.png     # 32x32 add-in icon
└── ReadMe.md                  # This file
```

## Building the Add-in

### Option 1: Using Visual Studio

1. **Open the Project**
   ```
   File → Open → Project/Solution
   Navigate to: c:\Users\Hafiz\Desktop\Github\ArcGIS Pro Plugin\BufferToolPlugin\BufferToolPlugin.csproj
   ```

2. **Restore NuGet Packages** (if needed)
   ```
   Right-click solution → Restore NuGet Packages
   ```

3. **Build the Solution**
   - Press `Ctrl+Shift+B` or
   - Go to **Build** → **Build Solution**

4. **Output Location**
   - Debug build: `bin\Debug\BufferToolPlugin.dll`
   - Release build: `bin\Release\BufferToolPlugin.esriAddinX`

### Option 2: Using Command Line

```powershell
# Navigate to project directory
cd "c:\Users\Hafiz\Desktop\Github\ArcGIS Pro Plugin\BufferToolPlugin"

# Build Debug version
dotnet build -c Debug

# Build Release version (creates .esriAddinX file)
dotnet build -c Release
```

## Debugging the Add-in

1. **Set ArcGIS Pro as Startup Program**
   - Visual Studio should automatically detect ArcGIS Pro
   - Or manually set: Right-click project → Properties → Debug → Start external program
   - Path: `C:\Program Files\ArcGIS\Pro\bin\ArcGISPro.exe`

2. **Start Debugging**
   - Press `F5` or click **Debug** → **Start Debugging**
   - ArcGIS Pro will launch with your add-in loaded

3. **Find Your Add-in**
   - Look for the **Buffer Tools** tab in the ArcGIS Pro ribbon
   - Two tools will be available:
     - **Interactive Buffer** (map tool)
     - **Buffer Selected Layer** (button)

4. **Set Breakpoints**
   - Click in the left margin of code to set breakpoints
   - The debugger will pause execution at breakpoints

## Installing the Add-in (Deployment)

### For Personal Use

1. **Build Release Version**
   ```
   Build → Configuration Manager → Set to "Release"
   Build → Build Solution
   ```

2. **Locate the .esriAddinX File**
   - Found in: `bin\Release\BufferToolPlugin.esriAddinX`

3. **Install**
   - Double-click the `.esriAddinX` file
   - Or copy to: `%LOCALAPPDATA%\ESRI\ArcGISPro\AddIns`
   - Restart ArcGIS Pro if already running

### For Enterprise Deployment

1. Distribute the `.esriAddinX` file to users
2. Users double-click to install, or
3. Use ArcGIS Pro Add-In Manager for organization-wide deployment

## Using the Add-in

### Interactive Buffer Tool

1. Open a map in ArcGIS Pro
2. Click the **Buffer Tools** tab
3. Click **Interactive Buffer** tool
4. Click anywhere on the map
5. A 100-meter buffer will be created at that location
6. Output saved to default geodatabase with timestamp

### Buffer Selected Layer

1. Open a map with feature layers
2. Select a feature layer in the Contents pane (click on layer name)
3. Click the **Buffer Tools** tab
4. Click **Buffer Selected Layer** button
5. All features in the selected layer will be buffered
6. Output saved to default geodatabase with timestamp

### Customizing Buffer Distance

By default, both tools use **100 Meters** as the buffer distance. To change this:

**Edit BufferTool.cs** (line 33):
```csharp
string bufferDistance = "100 Meters";  // Change to desired distance
```

**Edit BufferButton.cs** (line 65):
```csharp
string bufferDistance = "100 Meters";  // Change to desired distance
```

Valid distance formats:
- `"100 Meters"`
- `"50 Feet"`
- `"1 Kilometer"`
- `"0.5 Miles"`

## Troubleshooting

### Build Errors

**Error: Cannot find ArcGIS assemblies**
- Solution: Verify ArcGIS Pro is installed at `C:\Program Files\ArcGIS\Pro`
- If installed elsewhere, update `ProAssemblyPath` in `.csproj` file

**Error: Target framework not found**
- Solution: Install .NET 8.0 SDK from Microsoft

### Runtime Issues

**Add-in doesn't appear in ArcGIS Pro**
- Check ArcGIS Pro version matches (3.6.x)
- Verify add-in is installed: ArcGIS Pro → Project → Add-In Manager
- Check for errors in: `%LOCALAPPDATA%\ESRI\ArcGISPro\AssemblyCache`

**"No active map view" message**
- Solution: Create or open a map before using the tools

**"Please select a feature layer" message**
- Solution: Click on a feature layer name in the Contents pane before clicking Buffer Selected Layer button

### Image Issues

**Icons don't display**
- Replace placeholder `.png.txt` files with actual PNG images
- Recommended sizes: 16x16 and 32x32 pixels
- Use transparent backgrounds
- Format: PNG

## Customization Ideas

### Add a Dockpane for User Input
Create a WPF dockpane to let users specify:
- Buffer distance
- Dissolve options
- Line side/end types
- Output location

### Support Multiple Ring Buffers
Modify to create multiple concentric buffers at different distances.

### Field-Based Variable Distances
Use a field from the attribute table to define buffer distances per feature.

### Add Validation
Check spatial reference, geometry type, and feature count before executing.

## API Documentation

- [ArcGIS Pro SDK API Reference](https://pro.arcgis.com/en/pro-app/latest/sdk/api-reference)
- [ProConcepts: Geoprocessing](https://github.com/Esri/arcgis-pro-sdk/wiki/ProConcepts-Geoprocessing)
- [ProGuide: Your First Add-in](https://github.com/Esri/arcgis-pro-sdk/wiki/ProGuide-Build-Your-First-Add-in)
- [Community Samples](https://github.com/Esri/arcgis-pro-sdk-community-samples)

## 📸 Screenshots

![Buffer Tools Tab](https://via.placeholder.com/800x200/0079c1/ffffff?text=Buffer+Tools+Ribbon+Tab)

*The Buffer Tools tab appears in the ArcGIS Pro ribbon with two analysis tools.*

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Hafiz**

- GitHub: [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- Built with [ArcGIS Pro SDK for .NET](https://github.com/Esri/arcgis-pro-sdk)
- Esri Community for excellent documentation and support
- ArcGIS Pro SDK Community Samples

## 📞 Support

For issues related to this add-in:
- Open an [issue](https://github.com/yourusername/arcgis-pro-buffer-tool/issues) on GitHub

For ArcGIS Pro SDK questions:
- [Esri Community Forums](https://community.esri.com/t5/arcgis-pro-sdk-questions/bd-p/arcgis-pro-sdk-questions)
- [ArcGIS Pro SDK GitHub](https://github.com/Esri/arcgis-pro-sdk/issues)

---

**Version**: 1.0.0  
**Last Updated**: November 17, 2025  
**Compatible with**: ArcGIS Pro 3.6.x  
**Built with**: .NET 8.0, ArcGIS Pro SDK

---

⭐ **If you find this project useful, please consider giving it a star!** ⭐

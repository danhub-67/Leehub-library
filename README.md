# LeehHub — Documentation / Documentación

---

## Index / Índice

1. Load / Cargar
2. Window / Ventana
3. Tabs & Sections / Tabs y Sections
4. Elements / Elementos
5. DependsOn
6. Themes
7. Background / Fondo
8. Notifications / Notificaciones
9. Configs
10. Window Methods / Métodos de Window
11. Example / Ejemplo

---

## 1. Load / Cargar

🇺🇸
```lua
local LeehHub = loadstring(game:HttpGet("LINK"))()
```

```lua
local LeehHub = loadstring(readfile("LeehHub.lua"))()
```

🇪🇸
```lua
local LeehHub = loadstring(game:HttpGet("LINK"))()
```

```lua
local LeehHub = loadstring(readfile("LeehHub.lua"))()
```

---

## 2. Window / Ventana

🇺🇸
```lua
local Window = LeehHub:CreateWindow({
    Title = "Option 1",
    Description = "Option 2",
    Theme = "Aurora",
    Size = Vector2.new(600, 320),
    ToggleKey = Enum.KeyCode.RightShift,
    ThemeSelector = true,
    Transparency = 0.3,
    BackgroundImage = "LINK",
    BackgroundImageTransparency = 0.4,
    Logo = "LINK",
})
```

🇪🇸
```lua
local Window = LeehHub:CreateWindow({
    Title = "Opción 1",
    Description = "Opción 2",
    Theme = "Aurora",
    Size = Vector2.new(600, 320),
    ToggleKey = Enum.KeyCode.RightShift,
    ThemeSelector = true,
    Transparency = 0.3,
    BackgroundImage = "LINK",
    BackgroundImageTransparency = 0.4,
    Logo = "LINK",
})
```

| Option / Opción | Type / Tipo | Default | Description / Descripción |
|-----------------|-------------|---------|----------------------------|
| Title | string | LeehHub | Title / Título |
| Description | string | — | Subtitle / Subtítulo |
| Theme | string | Aurora | Initial theme / Theme inicial |
| Size | Vector2 | 600x320 | Size / Tamaño |
| ToggleKey | KeyCode | RightShift | Open / close / Abrir / cerrar |
| ThemeSelector | boolean | false | Theme selector / Selector de themes |
| Transparency | number | 0.3 | Panel transparency / Transparencia del panel |
| BackgroundImage | string | — | Background image / Imagen de fondo |
| BackgroundImageTransparency | number | 0.5 | Image transparency / Transparencia de la imagen |
| BackgroundVideo | string | — | Background video / Video de fondo |
| Logo | string | — | Window icon / Icono de la ventana |

---

## 3. Tabs & Sections / Tabs y Sections

🇺🇸
```lua
local Tab = Window:CreateTab("Option 1", "Option 2")
```

```lua
local Section = Tab:CreateSection("Option 1")
```

```lua
Tab:CreateToggle({ Name = "Option 1" })
```

🇪🇸
```lua
local Tab = Window:CreateTab("Opción 1", "Opción 2")
```

```lua
local Section = Tab:CreateSection("Opción 1")
```

```lua
Tab:CreateToggle({ Name = "Opción 1" })
```

---

## 4. Elements / Elementos

Common properties / Propiedades comunes:

| Property / Propiedad | Type / Tipo | Description / Descripción |
|----------------------|-------------|---------------------------|
| Name / Title | string | Text / Texto |
| Icon | string | Icon / Icono |
| IconPosition | Left / Right | Icon position / Posición del icono |
| Flag | string | Saves the value / Guarda el valor |
| DependsOn | table / function | Visibility condition / Condición de visibilidad |
| Callback | function | On change / Al cambiar |

---

### Toggle

🇺🇸
```lua
local Toggle = Section:CreateToggle({
    Name = "Option 1",
    Default = false,
    Flag = "Option 2",
    Callback = function(value)
    end,
})
```

```lua
Toggle:Set(true)
Toggle:Get()
```

🇪🇸
```lua
local Toggle = Section:CreateToggle({
    Name = "Opción 1",
    Default = false,
    Flag = "Opción 2",
    Callback = function(value)
    end,
})
```

```lua
Toggle:Set(true)
Toggle:Get()
```

---

### Slider

🇺🇸
```lua
local Slider = Section:CreateSlider({
    Name = "Option 1",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "Option 2",
    Callback = function(value)
    end,
})
```

```lua
Slider:Set(25)
Slider:Get()
```

🇪🇸
```lua
local Slider = Section:CreateSlider({
    Name = "Opción 1",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "Opción 2",
    Callback = function(value)
    end,
})
```

```lua
Slider:Set(25)
Slider:Get()
```

---

### Range Slider

🇺🇸
```lua
local Range = Section:CreateRangeSlider({
    Name = "Option 1",
    Min = 0,
    Max = 100,
    Default = {20, 80},
    Callback = function(low, high)
    end,
})
```

```lua
Range:Set(10, 90)
local low, high = Range:Get()
```

🇪🇸
```lua
local Range = Section:CreateRangeSlider({
    Name = "Opción 1",
    Min = 0,
    Max = 100,
    Default = {20, 80},
    Callback = function(low, high)
    end,
})
```

```lua
Range:Set(10, 90)
local low, high = Range:Get()
```

---

### Button

🇺🇸
```lua
Section:CreateButton({
    Name = "Option 1",
    Callback = function()
    end,
})
```

🇪🇸
```lua
Section:CreateButton({
    Name = "Opción 1",
    Callback = function()
    end,
})
```

---

### Dropdown

🇺🇸
```lua
local Drop = Section:CreateDropdown({
    Name = "Option 1",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Multi = false,
    Flag = "Option 2",
    Callback = function(value)
    end,
})
```

```lua
Drop:Set("Option 2")
Drop:Get()
```

🇪🇸
```lua
local Drop = Section:CreateDropdown({
    Name = "Opción 1",
    Options = {"Opción 1", "Opción 2", "Opción 3"},
    Default = "Opción 1",
    Multi = false,
    Flag = "Opción 2",
    Callback = function(value)
    end,
})
```

```lua
Drop:Set("Opción 2")
Drop:Get()
```

`Multi = true` → multi select / selección múltiple.

---

### Color Picker

🇺🇸
```lua
local Color = Section:CreateColorPicker({
    Name = "Option 1",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "Option 2",
    Callback = function(color)
    end,
})
```

🇪🇸
```lua
local Color = Section:CreateColorPicker({
    Name = "Opción 1",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "Opción 2",
    Callback = function(color)
    end,
})
```

---

### Input

🇺🇸
```lua
local Input = Section:CreateInput({
    Name = "Option 1",
    Placeholder = "Option 2",
    Default = "",
    Flag = "Option 3",
    Callback = function(text)
    end,
})
```

```lua
Input:Set("Option 1")
Input:Get()
```

🇪🇸
```lua
local Input = Section:CreateInput({
    Name = "Opción 1",
    Placeholder = "Opción 2",
    Default = "",
    Flag = "Opción 3",
    Callback = function(text)
    end,
})
```

```lua
Input:Set("Opción 1")
Input:Get()
```

---

### Text Area

🇺🇸
```lua
local Area = Section:CreateTextArea({
    Name = "Option 1",
    Placeholder = "Option 2",
    Height = 120,
    Default = "",
    Callback = function(text)
    end,
})
```

```lua
Area:Set("Option 1")
Area:Get()
Area:GetLines()
```

🇪🇸
```lua
local Area = Section:CreateTextArea({
    Name = "Opción 1",
    Placeholder = "Opción 2",
    Height = 120,
    Default = "",
    Callback = function(text)
    end,
})
```

```lua
Area:Set("Opción 1")
Area:Get()
Area:GetLines()
```

---

### Progress Bar

🇺🇸
```lua
local Progress = Section:CreateProgressBar({
    Name = "Option 1",
    Min = 0,
    Max = 100,
    Default = 0,
    ShowPercent = true,
})
```

```lua
Progress:Set(75)
```

🇪🇸
```lua
local Progress = Section:CreateProgressBar({
    Name = "Opción 1",
    Min = 0,
    Max = 100,
    Default = 0,
    ShowPercent = true,
})
```

```lua
Progress:Set(75)
```

---

### Table

🇺🇸
```lua
local Table = Section:CreateTable({
    Name = "Option 1",
    Columns = {"Option 1", "Option 2", "Option 3"},
    ColumnWidths = {0.4, 0.3, 0.3},
    MaxHeight = 180,
    Rows = {
        {"Option 1", "Option 2", "Option 3"},
        {"Option 1", "Option 2", "Option 3"},
    },
})
```

```lua
Table:SetRows({{"Option 1", "Option 2"}})
Table:AddRow({"Option 1", "Option 2"})
Table:Clear()
Table:GetRows()
```

🇪🇸
```lua
local Table = Section:CreateTable({
    Name = "Opción 1",
    Columns = {"Opción 1", "Opción 2", "Opción 3"},
    ColumnWidths = {0.4, 0.3, 0.3},
    MaxHeight = 180,
    Rows = {
        {"Opción 1", "Opción 2", "Opción 3"},
        {"Opción 1", "Opción 2", "Opción 3"},
    },
})
```

```lua
Table:SetRows({{"Opción 1", "Opción 2"}})
Table:AddRow({"Opción 1", "Opción 2"})
Table:Clear()
Table:GetRows()
```

---

### Keybind

🇺🇸
```lua
local Key = Section:CreateKeybind({
    Name = "Option 1",
    Default = Enum.KeyCode.Q,
    Flag = "Option 2",
    Callback = function(key)
    end,
})
```

🇪🇸
```lua
local Key = Section:CreateKeybind({
    Name = "Opción 1",
    Default = Enum.KeyCode.Q,
    Flag = "Opción 2",
    Callback = function(key)
    end,
})
```

---

### Label / Paragraph / Divider

🇺🇸
```lua
Section:CreateLabel("Option 1")
```

```lua
Section:CreateParagraph("Option 1")
```

```lua
Section:CreateDivider()
```

🇪🇸
```lua
Section:CreateLabel("Opción 1")
```

```lua
Section:CreateParagraph("Opción 1")
```

```lua
Section:CreateDivider()
```

---

### Search

🇺🇸
```lua
Tab:CreateSearch({
    Placeholder = "Option 1",
})
```

🇪🇸
```lua
Tab:CreateSearch({
    Placeholder = "Opción 1",
})
```

---

## 5. DependsOn

🇺🇸 With object:

```lua
local Toggle = Section:CreateToggle({
    Name = "Option 1",
    Default = false,
})

Section:CreateSlider({
    Name = "Option 2",
    Min = 1,
    Max = 10,
    Default = 5,
    DependsOn = { Toggle = Toggle, Value = true },
})
```

With function:

```lua
DependsOn = function()
    return LeehHub:GetFlag("Option 1") == true
end
```

🇪🇸 Con objeto:

```lua
local Toggle = Section:CreateToggle({
    Name = "Opción 1",
    Default = false,
})

Section:CreateSlider({
    Name = "Opción 2",
    Min = 1,
    Max = 10,
    Default = 5,
    DependsOn = { Toggle = Toggle, Value = true },
})
```

Con función:

```lua
DependsOn = function()
    return LeehHub:GetFlag("Opción 1") == true
end
```

---

## 6. Themes

```text
Aurora          NeonPurple      NeonCyan        NeonPink
NeonLime        NeonOrange      Synthwave       Cyberpunk
Toxic           GlassFrost      GlassObsidian   GlassRose
Bloodmoon       EmeraldGlass    Royal           Arctic
Vaporwave       Blackout        Galaxy          Sunset
Ocean           Sakura          Inferno         Matrix
```

🇺🇸 Only Inferno and Matrix have background animations.  
With a background image, themes only color icons, text and accents.

```lua
Window:SetTheme("Option 1")
```

```lua
LeehHub:SetTheme("Option 1")
```

🇪🇸 Solo Inferno y Matrix tienen animaciones de fondo.  
Con imagen de fondo, los themes solo colorean iconos, texto y acentos.

```lua
Window:SetTheme("Opción 1")
```

```lua
LeehHub:SetTheme("Opción 1")
```

---

## 7. Background / Fondo

🇺🇸 On create:

```lua
BackgroundImage = "LINK",
BackgroundImageTransparency = 0.4,
BackgroundVideo = "LINK",
```

At runtime:

```lua
Window:SetBackgroundImage("LINK", 0.4)
```

```lua
Window:SetBackgroundVideo("LINK")
```

```lua
Window:SetBackgroundImageTransparency(0.5)
```

🇪🇸 Al crear:

```lua
BackgroundImage = "LINK",
BackgroundImageTransparency = 0.4,
BackgroundVideo = "LINK",
```

En runtime:

```lua
Window:SetBackgroundImage("LINK", 0.4)
```

```lua
Window:SetBackgroundVideo("LINK")
```

```lua
Window:SetBackgroundImageTransparency(0.5)
```

---

## 8. Notifications / Notificaciones

🇺🇸
```lua
LeehHub:Notify({
    Title = "Option 1",
    Content = "Option 2",
    Duration = 3.5,
    Type = "Success",
})
```

🇪🇸
```lua
LeehHub:Notify({
    Title = "Opción 1",
    Content = "Opción 2",
    Duration = 3.5,
    Type = "Success",
})
```

Types: `Success` | `Error` | `Warning` | `Info`

---

## 9. Configs

🇺🇸
```lua
LeehHub:SaveConfig("Option 1")
```

```lua
LeehHub:LoadConfig("Option 1")
```

```lua
LeehHub:SetFlag("Option 1", 50)
```

```lua
local v = LeehHub:GetFlag("Option 1")
```

Folder: `LeehHub_Configs/`

🇪🇸
```lua
LeehHub:SaveConfig("Opción 1")
```

```lua
LeehHub:LoadConfig("Opción 1")
```

```lua
LeehHub:SetFlag("Opción 1", 50)
```

```lua
local v = LeehHub:GetFlag("Opción 1")
```

Carpeta: `LeehHub_Configs/`

---

## 10. Window Methods / Métodos de Window

| Method / Método | Description / Descripción |
|-----------------|---------------------------|
| CreateTab | Creates a tab / Crea un tab |
| SetTheme | Changes theme / Cambia theme |
| SetBackgroundImage | Changes image / Cambia imagen |
| SetBackgroundVideo | Changes video / Cambia video |
| SetBackgroundImageTransparency | Image transparency / Transparencia de imagen |
| Minimize | Minimize / Minimiza |
| Restore | Restore / Restaura |
| Destroy | Destroys the UI / Destruye la UI |

---

## 11. Example / Ejemplo

🇺🇸
```lua
local LeehHub = loadstring(game:HttpGet("LINK"))()

local Window = LeehHub:CreateWindow({
    Title = "Option 1",
    Theme = "Aurora",
    ThemeSelector = true,
    BackgroundImage = "LINK",
    BackgroundImageTransparency = 0.45,
})

local Tab = Window:CreateTab("Option 1")
local Section = Tab:CreateSection("Option 2")

local Toggle = Section:CreateToggle({
    Name = "Option 1",
    Flag = "Option 2",
    Callback = function(v)
    end,
})

Section:CreateSlider({
    Name = "Option 3",
    Min = 5,
    Max = 50,
    Default = 15,
    Flag = "Option 4",
    DependsOn = { Toggle = Toggle, Value = true },
})

Section:CreateButton({
    Name = "Option 5",
    Callback = function()
        LeehHub:SaveConfig("Option 1")
        LeehHub:Notify({
            Title = "Option 1",
            Content = "Option 2",
            Type = "Success",
        })
    end,
})
```

🇪🇸
```lua
local LeehHub = loadstring(game:HttpGet("LINK"))()

local Window = LeehHub:CreateWindow({
    Title = "Opción 1",
    Theme = "Aurora",
    ThemeSelector = true,
    BackgroundImage = "LINK",
    BackgroundImageTransparency = 0.45,
})

local Tab = Window:CreateTab("Opción 1")
local Section = Tab:CreateSection("Opción 2")

local Toggle = Section:CreateToggle({
    Name = "Opción 1",
    Flag = "Opción 2",
    Callback = function(v)
    end,
})

Section:CreateSlider({
    Name = "Opción 3",
    Min = 5,
    Max = 50,
    Default = 15,
    Flag = "Opción 4",
    DependsOn = { Toggle = Toggle, Value = true },
})

Section:CreateButton({
    Name = "Opción 5",
    Callback = function()
        LeehHub:SaveConfig("Opción 1")
        LeehHub:Notify({
            Title = "Opción 1",
            Content = "Opción 2",
            Type = "Success",
        })
    end,
})
```

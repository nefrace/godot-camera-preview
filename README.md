# Nefrace's Camera Preview plugin

Allows you to add a small preview window inside main editor's view to show the preview of the selected camera.

It can search through the children of selected node to find a Camera node (disabled by default)

## Installation

- Clone this repo inside "addons" folder of your project
- Enable it from "Plugins" section inside Project Settings
- Go to 3D view and toggle option "Visible" inside "Camera preview" menu on the toolbar
- enjoy!

## Node search modes

There's 3 search modes that can help to find a Camera node in the children of the selected node:

- **Disabled** - only selected node is checked
- **By name** - uses `find_node` method with defined search mask (_"Camera*"_ by default)
- **By class** - recursively checking all children for type **Camera** (Not tested well, may not work with instantiated packed scenes)



https://user-images.githubusercontent.com/18103556/172067736-6ec689b5-15ab-4848-8d85-b2a71b527c71.mp4


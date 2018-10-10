# guidrasil
ABAP GUI designer for Prototyping and more

# about
Yggdrasill is an immense mythical tree that connects the nine worlds in Norse cosmology. It holds together everything in the world. It's the beginning of all. If yggdrasill will die, the world will die.

Wikipedia: https://en.wikipedia.org/wiki/Yggdrasil

The project name _guidrasil_ shall indicate that the SAPGUI is still the center of everything. If SAPGUI will die, the world ends. 

# idea
guidrasil is a GUI-Designer which I started to build with a former colleague. The idea is that every control can be generically managed. You just need a unique, standardized shell wrapped around the controls so that they can be created all the same. 

For placing the controls we created a framework that provides functions for selecting the type of container and inside the container functions for selecting the controls.

Controls and container are similar. The great difference is, that containers can held more containers (splitter container) and controls can have different attributes.

Each control can be created with a method CREATE. Inside this method everything will be done for creating the neccessary things. The container has a function to change the name of the controls and set attributes (show/ hide status bar in TextEditControl or the picture in PictureControl.

All controls have a defined structure for managing these attributes. But the attributes will be saved with one generic function using serialization.

# controls
this project starts with following containers:
- docking container
- custom container
- dialogbox container
- splitter container
These two controls can be used for start:
- icons (picture control)
- text (textedit control)
- calendar (calendar control)

# detail
You can see a detailed overview in this prezi-presentation that I held 2017 at sitwdf:
http://prezi.com/rhil_uifj7rn/?utm_campaign=share&utm_medium=copy


# guidrasil
ABAP GUI designer for Prototyping and more
![overview](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_07.png)

# about
Yggdrasill is an immense mythical tree that connects the nine worlds in Norse cosmology. It holds together everything in the world. It's the beginning of all. If yggdrasill will die, the world will die.

Wikipedia: https://en.wikipedia.org/wiki/Yggdrasil

The project name _guidrasil_ shall indicate that the SAPGUI is still the center of everything. If SAPGUI will die, the world ends. 

# idea
guidrasil is a GUI-Designer which I started to build with a former colleague. The idea is that every control can be generically managed. You just need a unique, standardized shell wrapped around the controls so that they can be created all the same. 

For placing the controls we created a framework that provides functions for selecting the type of container and inside the container functions for selecting the controls.
![functions](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_02.png)

Controls and container are similar. The great difference is, that containers can held more containers (splitter container) and controls can have different attributes.

Each control can be created with a method CREATE. Inside this method everything will be done for creating the neccessary things. The container has a function to change the name of the controls and set attributes (show/ hide status bar in TextEditControl or the picture in PictureControl.
![attributes](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_06.png)

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

# features

## prototyping
With guidrasil you can prototype an application as easy as never before. You just need to click the controls you want and save the project.

## code creation
As every object in its shell knows what to do to display the control, it can provide the code for creation. The guidrasil manager class knows where the containers are placed and which controls are in there. So you can generate a complete genuine ABAP program for displaying these controls.

## object manager
The application provides a GUI for you to select all the containers and controls. But the application can display all controls also without the drop down functions. And the manager also knows the names of the controls. So you are able to just create the project with the manager class and then get the reference of objects by their names. Afterwards you can manipulate the object in the way you are used to it.

## visualize settings
All the settings of a control can be customized. For example you can set the attribute "hide statusbar" in the TextEditControl via listbox. At least you could define the complete fieldcatalog of an alv grid in the dialog.  

# screenshots

initial screen
placing docking containers, custom container and dialogbox

![01](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_01.png)

Empty custom container on the left

![02](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_02.png)

Add a splitter container

![03](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_03.png)

Add an icon control

![04](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_04.png)

Select number of columns and rows for new splitter container

![05](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_05.png)

attributes window with documentation for TextEditControl

![06](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_06.png)

some controls and dialog box (design mode)

![07](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_07.png)

Some controls and dialog box (preview)

![08](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_08.png)

hierarchical Tree view

![09](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_09.png)

icon selection

![10](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_10.png)

Change name of control

![11](https://github.com/tricktresor/guidrasil/blob/master/docs/guidrasil_11.png)

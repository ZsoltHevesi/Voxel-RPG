# Project Title: Trial Vox

1
Name: Daniel O'Neill

Student Number: C22307066

Class Group: Tu858

Github: [https://github.com/danielo127730](https://github.com/danielo127730/Voxel-RPG)


2
Name: Georgy Kachelkin

Student Number: D22124642

Class Group: TU856

Github: https://github.com/gk355


3
Name: Yan Savioli Castanheira

Student Number: C22371301

Class Group: TU858

Github: https://github.com/Yan-Sav/Yan-Voxel-RPG

4
Name: Zsolt Hevesi

Student Number: C22387231

Class Group: TU858

Github: https://github.com/ZsoltHevesi

# Video

[![TrialVoxTrailer](https://img.youtube.com/vi/dmLDlVRioho/0.jpg)](https://www.youtube.com/watch?v=dmLDlVRioho)

# Screenshots
![Screenshot (473)](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/796ab697-9a9a-4d42-81df-f7e978ff1304)
![image3](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/0f4ada51-ccd0-4300-948b-123f2c547059)
![image1](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/291af71b-c1d4-4f16-af1c-db4389bb8255)
![image2](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/2dc85c3d-75cc-4d34-ab1a-b775b8d3883f)
![Screenshot (471)](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/90be4a76-c453-4a96-8c66-cb2e097c4382)
![Screenshot (478)](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/a54ad6b1-d5f2-45d7-bb50-529103dadd0d)
![image](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/cdca96d3-779d-4c90-a5bf-e7f8cd8a350b)


# Description of the project
Trial Vox is a stylised 3D action RPG where the player goes through levels fighting enemies and gaining loot to help them survive, while trying to avoid dying themselves. 

# Instructions for use
| Key(s) | Action |
|-----------|-----------|
| W | Move forward |
| A | Move left |
| S | Move backward |
| D | Move right |
| SPACE | Jump |
| TAB | Open inventory |
| Left Mouse Button | Melee Attack |
| Right Mouse Button | Aim gun (only if equipped) |
| Right Mouse Button + Left Mouse button | Shoot gun (only if equipped) |

To equip items, click and drag an item into the correct slot (a "stop" icon will appear if an item can not be equipped in the slot you're hovering over)

![inventory](https://github.com/ZsoltHevesi/Voxel-RPG/assets/124164938/442722b2-f3e1-41f2-b56d-4bf1d92ab4c0)


To complete the game, kill all enemies in Level 2.

# How it works:
The Player controller works by using standard move_and_slide() code similar to the default one that Godot comes with, but we added a script which rotates seperation rays (one block/voxel high) which allow the player to walk up stairs for convenience. The player also has an off-set camera with a collision spring to get the effect that most 3rd person games such as Warframe use, and an Animation Tree to play different animations such as walk, attack and jump.

Code relating to the inventory involves opening the database.json file in AutoLoad (which allows every script in the game to access it) and getting the proterties (such as respective icons, scenes, item ID and stats). When an enemy is killed, they will drop a random item which can be picked up and equipped by the player in the inventory, which will reflect the item properties visually and by taking less damage based on the gear they are wearing.

Enemies work by being Navigation Agents of a Navigation mesh/region. When the player enters a certain radius of an enemy, they will begin following a path while avoiding obstacles to reach the player and begin attacking, if an attack hits the player or an enemy, they will begin taking damage until killed.

# List of classes/assets in the project

| Class/asset | Source |
|-----------|-----------|
| player.gd | Heavily modified from [reference 1](https://github.com/majikayogames/godot-character-controller-stairs) and [reference 2](https://www.youtube.com/watch?v=EP5AYllgHy8&t=1273s) |
| e_clanger.gd | Modified from [reference](https://www.youtube.com/watch?v=-juhGgA076E) |
| guardianEnemy.gd | Modified from [reference](https://www.youtube.com/watch?v=-juhGgA076E) |
| abstractItem.gd | Modified from [reference](https://pastebin.com/YaPzmyqv) |
| character.gd | Modified from [reference](https://pastebin.com/iJA2KbCe) |
| inventory.gd | Modified from [reference](https://pastebin.com/chGct0NK) |
| passive_slot.gd | Modified from [reference](https://pastebin.com/McWfmCZH) |
| slot.gd | Modified from [reference](https://pastebin.com/SzuLRxGV) |
| stats.gd | Modified from [reference](https://pastebin.com/Rdr4ALkK) |
| UI.gd | Modified from [reference](https://pastebin.com/vTTj9npA) |
| database.gd | Modified from [reference](https://pastebin.com/jdVUGRP3) |
| database.json | Heavily modified from [reference](https://pastebin.com/ppZTCirg) |

All other assets are original and either self written, modelled, textured or animated.

# What I am most proud of in the assignment

Each team member

1(Daniel):
I am proud of being apart of this project and undertaking the challenge that it was. I am proud of my efforts and particularly the efforts of my team.

The specific contributions which i'm most proud of implementing  in the game are the sprint functionality, Audio,  contributions to the health system, implementing a smoother camera using linear interpolation, implementing 3d pathfiding / enemy navigation, introducing damage incurring barriers and pioneering the enemy / player damage system. 

 There were many times when I would struggle to implement a feature. I would spend hours research and attempting to solve the problem. It was stressful but I persevered as did my team which faced similar difficulties and eventually we would overcomes these problems through collaboration and perseverance. I went into this project knowing absoulutely nothing about godot and game design. Despite my lack of knowledge I took on this challenge anyway and I've learned so much from it. The game turned out better than I ever could've imagined compared to where we began.  

2():

3(Yan):
I am proud of having implemented the basic elements of functionality and display for player health which were later refined by Zsolt, Daniel and Georgy, I t isn't a big achievement but I'm happy with how it turned out given this was my first time writing code for a game in gd script.

4(Zsolt Hevesi):
I am proud of the 100% original assets (player gear, enemies, levels etc.) me and George created through the MagicaVoxel and Blender tools as well as Godot's built-in tools, the original animations created in Godot's animation editor, complex inventory management and database, and the visuals (eg. VoxelGI lighting, materials, refraction etc.).

# What I learned

Each team member

1(Daniel):
I've learned a lot from this project. It improved my github and git command competency immensely. I learned how to use the godot game engine and gdscript.  I've experienced what it's like to work on complex problems with a team and collaborate on solutions to overcome those problems. I've learned about the process of designing a game and the various elements that go into it. It's given me a greater appreciation for the games that I play and the amount of work that must have went into their creation.

2():

3(Yan):
I learned that there are various way that you can give a model animations be either through programs like Blender or through websites with pre-built animations and models like Mixamo, when deciding how to go about giving models animations with a website like Mixamo you must ensure that the models has a bone structure already set up and that the model does not have any floating parts which are not connected to the body so it can be imported to the Mixamo website and converted into a standard Mixamo model to have animations given to it. This allows the model to be given any animation that Mixamo has available and when all desired animations have been acquired you can export the the converted model with the animations to use in the game, also if the need to share the same animations between different models arises there is a way to export only the desired animations with the help of Blender so that as long as the models sharing animations are Mixamo models any animations can be shared between them.

4(Zsolt Hevesi):
This is my first time fully diving into a 3D game engine that is also open source, so everything I contributed to was learned through making this project. I learned things such as Nodes, GDScript, game optimisation, Editor tools (animation, UI elements, materials, input maps etc.) and so much more. As a result of using original assets, I also learned other tools such as MagicaVoxel and Blender for 3D modelling for the first time.
I learned how to create a fully function Player controller that walks, runs, jumps, climbs stairs, an inventory system with slot types, meaningful item stats, icons and updating the visuals of the player to match the inventory, how to create working pathfinding enemies, level design, and how to manage a small team of developers.

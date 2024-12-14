# COMP-360-Assignment-4
**Introduction**

This project implements a 3D robotic arm simulation with interactive grabbing mechanics using the Godot Engine 4.x. The simulation features realistic arm movements, object interaction physics, and camera controls.

**Project Overview**

The simulation demonstrates advanced 3D physics interactions through a robotic arm that can grab, hold, and throw objects in a 3D environment. The project incorporates skeletal animations, rigid body physics, and user input handling.

**Core Features**

**1. Arm Movement and Control**

Fully articulated robotic arm with skeletal animation
Smooth camera control system with mouse input
Configurable movement speed and sensitivity
Jump mechanics with gravity implementation

**2. Object Interaction System**

Dynamic object grabbing and throwing mechanics
Physics-based object manipulation
Ray casting for object detection
Configurable throw force and object following behavior

**3. Animation System**

State-based animation system using AnimationTree
Smooth transitions between grab and release states
IK (Inverse Kinematics) target system for arm positioning

**Technical Implementation**

**Movement System**

const SPEED = 5.0
const JUMP_VELOCITY = 5.5
const LERP_VAL = .15

**Object Interaction Parameters**

@export var throwForce = 7.5

@export var followSpead = 5.0

@export var followDistance = 2.5

@export var maxDistanceFromCanere = 5.0

**Input Controls**

1. WASD: Movement controls
2. Mouse: Camera control
3. X: Grab object
4. C: Release/throw object
5. Z: Pick up object
6. Space: Jump
7. ESC: Quit application

**Core Components**

**Animation System**

The project utilizes Godot's animation system with the following states:

1. Default
2. Grab
3. Idle
4. Let go        
5. Pickup

**Physics Integration**

1. Implements gravity and collision detection
2. Uses RigidBody3D for physical object interactions
3. Raycasting for object detection and interaction

**Camera System**

func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x*sens))
        pivot.rotate_x(deg_to_rad(-event.relative.y*sens))
        pivot.rotation.x=clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

# Setup and Configuration

**Prerequisites**

Godot Engine 4.x
Basic understanding of 3D physics and animation systems

**Project Structure**

-node_3d.tscn: Main scene file

-arm.gd: Core arm control script

-player.gd: Player movement and interaction script

-Animation and 3D model resources

**Future Enhancements**

-Enhanced physics interactions

-Additional arm articulation points

-More complex grabbing mechanics

-Advanced object manipulation features

**Technical Notes**

-The simulation runs on Godot's built-in physics engine

-Uses skeletal animation system for arm movement

-Implements custom collision detection and response

-Features configurable physics parameters for fine-tuning

**Development Process**

The project was developed with a focus on realistic physics interactions and smooth user control, utilizing Godot's built-in physics and animation systems while maintaining performance optimization.

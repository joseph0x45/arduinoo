# arduinoo
Lua plugin that provide a little set of useful commands for working with Arduin

## Installation
You can install this plugin with your favorite package manager
### Packer
```
    use "joseph0x45/arduinoo"
```
You also need a few dependencies:
- arduino-cli
- wc
- test


## ArduinooCheckDependencies
This command will check if you have all the dependencies installed on your system in order for this plugin to work properly


## ArduinooCreateSketch
This command will create a new project in the current directory. You can also use a starter example with this syntax
```
:ArduinooCreateSketch <example>
```
The plugin provides autocomplete for the available examples all taken from the official Arduino examples


## ArduinooCompile
This command will compile the current project. For this to work you need to run `arduino-cli board attach` to generate a `sketch.yml` file

## ArduinooUpload
This command will upload the compiled project to the correct port

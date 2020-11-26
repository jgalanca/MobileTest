# Marvel Characters

The app shows the list of Marvel characters provided by Marvel's API(​https://developer.marvel.com/docs​). User can navigate to the detail of a character, where the information is shown, as well as the comics and series, where the character can be found.

# Project Information

Project allows user to:

* View the list of all Marvel characters
* Search of a Maverl character by name
* View the detail of a Marvel character, with the information about comics and series.

## Project Configuration

Once the project is downloaded, you must follow next steps:

* Open the terminal and navigate to the directory of project ```cd MobileTest```.
* The project includes third part libraries, this dependencies are installed with Cocoapods ```pod install```.
* Open the workspace ```open Marvel.xcworkspace```.
* Marvel's API needs authentication so the first thing to do is configure both the public and private keys at ```MarvelApi.swift*``` file.

## Project Protocols

This projects allows to list any kind of object. All you have to do is to heritance **CustomTableObjectProtocol** and **CustomTableCellProtocol**.

These protocols request all the methods needed to get the information, and fill all the information into a cell of a table.  

## Third Part Libraries

* [**SwiftLint**](https://github.com/realm/SwiftLint)
* [**CryptoSwift**](https://github.com/krzyzanowskim/CryptoSwift)
* [**Kingfisher**](https://github.com/onevcat/Kingfisher)
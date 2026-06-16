# Presentation Autorunner

A Windows system tray utility (Delphi/Pascal) that automatically detects when a USB drive is inserted and launches any PowerPoint presentation found on it.

## What it does

Designed for presentation scenarios where a speaker needs to plug in a USB drive and have their slideshow start immediately — no manual navigation required.

- Runs silently in the Windows system tray on startup
- Listens for USB drive insertion via Windows `WM_DEVICECHANGE` messages
- When a drive is connected, searches it for `.pptx`, `.ppt` or `.pps` files
- Renames the found file to `.pps` (PowerPoint Show format) to force slideshow mode
- Launches the presentation automatically via `ShellExecute`
- Registers itself to run on Windows startup via the registry
- Double-clicking the tray icon restores the main window

## Tech stack

- Delphi (Object Pascal) — VCL desktop application
- Windows API (`WM_DEVICECHANGE`, `ShellExecute`, Registry)

## Notes

- Only the first presentation found on the drive is launched
- The original file is renamed in-place on the USB drive — keep a backup copy
- USB detection logic is based on a solution from Experts Exchange (credited in source)

## Building

Open `PresentationAutoRunner.dproj` in Embarcadero Delphi (tested on Delphi 11 Alexandria).

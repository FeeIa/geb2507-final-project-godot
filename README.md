# ImmunoDefender - A Cellular Combat Journey
A serious game where players command the immune system, represented as immune cells, to identify and eliminate invading pathogens while learning how cellular defense works in a more game-like and engaging way.

The game consists of two levels in the final prototype deliverables for submission.

## Project Information
This was a final project in Fall 2025 of the following:
- Course: GEB2507 - AI-Driven Virtual Worlds and Serious Games for Societal Applications
- Instructor: Sahba Zojaji
- University: The Chinese University of Hong Kong, Shenzhen

## Team
- Xu Sule (124020406, 124020406@link.cuhk.edu.cn) - Narrative & Content Writer
- Song Yanrui (123020232, 123020232@link.cuhk.edu.cn) - Gameplay & Balancing Lead
- Xiong Jiaying (122020227, 122020227@link.cuhk.edu.cn) - Asset & UI Artist
- Bryan Edelson (124040016, 124040016@link.cuhk.edu.cn) - Lead Developer

## Play & Downloads
- **Play in browser (live):** https://immunodefender.netlify.app/geb2507%20final%20project
- **Desktop build (.exe):** `builds/pc.zip`
- **Android build (.apk):** `builds/android.zip`

## Run in Godot
- Engine: Godot 4.5
- Clone this repository as a ZIP file, then extract it as a folder.
- Open the extracted folder in Godot.
- Click the Run button to launch the main scene of the game.

## Purpose & Learning Goals
- Visualize the immune system through approachable, game-forward mechanics.
- Reinforce systems thinking: threat detection, resource allocation, and proper timing.
- Support learning in a fun way through serious game design choices.

## Findings & Evaluation
- High completion (88.5%) across mixed backgrounds shows accessibility and engagement.
- Players rated art and controls positively; difficulty felt appropriate, balancing challenge and fun.
- Knowledge gains were significant (pre/post 4.96 --> 8.29), meeting the educational objective.
- Emotional feedback was mostly positive; curiosity rose, but self-care/immune-system inspiration (NPS-style) was only moderate.
- Qualitative notes praised visuals/playability and asked for clearer instructions, feature polish, and richer educational context.

## Gameplay
- Deploy immune units (e.g., macrophage, B-cells, etc.) to attack waves of pathogens (viruses, bacteria, etc.)
- Manage limited energy (ATP) with evolving threats as the game progresses.
- Buy consumables to buff your immune cells, which represent certain immune responses.

## Game Design Process
- Iterative loops of prototype --> internal playtest --> balance tweaks to pacing and resource costs.
- UI refinements focused on readability and a pastel-like and pixel-like look to match the 2D game atmosphere.
- Observed that players engaged most when the escalation curve surfaced new abilities gradually.

## Project Repository
The project repository can be found here: https://github.com/FeeIa/geb2507-final-project-godot

The root is the entire game's project folder and is the root path to be exported to Godot.
- `builds/web` - Web export (used for Netlify or GitHub Pages deployment)
- `builds/pc.zip`, `builds/android.zip` - Desktop/Android builds
- `scenes`, `scripts`, `assets` - Godot project content
- `project.godot`, `export_presets.cfg` - Engine configuration

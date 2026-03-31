# HandBrake-Auto-Encoder
This project allows you to run HandBrake on a given directory on a set basis. The idea was to have a tool that can encode video files that are unecessarly large. By default the scirpt uses HandBreak's 1080p30FPS preset.

# What can you do with this?
AutoEncoder_V is a powershell script that takes in an array of directories and will use Handbreak to encode all MKV fiiles larger than 1GB. It is designed to be ran in something like task scheduler where you can have it run automatically.

AutoEncoder_OnDemand_V is a powershell script that does the same thing however is designed to be ran on demand. It will prompt you for either a single directory or a text file that contains multiple directories .

# How do you get started?
1. Download and install handbrake CLI. https://handbrake.fr/downloads2.php

   <img width="1211" height="582" alt="image" src="https://github.com/user-attachments/assets/0c9a0519-579b-44e2-9daa-0bbc0f8e0cdc" />

3. In the script you want to run, set the $HandbrakeDirectory variable to where you installed handbrake to. (It is located at the top of the script.)
   
   <img width="861" height="68" alt="image" src="https://github.com/user-attachments/assets/2020d631-339f-4dc7-8ebd-18e847b529cf" />

4. If you are configuring the automatic version, update the $DirectoriesToEncode variable to the directories you want to scan. (It is currently set to scan Y:\Library\Anime NAS and Y:\Library\TV NAS). If you are using the on demand version, skip this.
   
   <img width="715" height="56" alt="image" src="https://github.com/user-attachments/assets/e69efd0e-e299-4e62-9427-824ac402f7bf" />

6. Open ExpectionsList.csv and update it with the files you want to exclude. Some examples have been left to showcase how it should be formatted.
   
   <img width="1383" height="160" alt="image" src="https://github.com/user-attachments/assets/83b537c1-bf94-4894-998e-a40d7bd8018a" />

8. Run the script!

   <img width="286" height="61" alt="image" src="https://github.com/user-attachments/assets/973c4fd7-5f04-4ad2-9e9e-4044fedffd0a" />

# Frequently Asked Questions
1. How can I monitor this?
   
   A transcript is created and stored in the logs folder. You can consult this after the script is running.
   You can also run it in VScode to watch it run in realtime.

3. What is the difference between the On demand and the regular version?
   
   The on demand version asks for user input and dosen't have the exceptions list built in. This is so that you can run it on a one off basis.
   The normal version is designed to run automatically without user input.

5. What happens to the orginal files?
   
   If the encoded file is smaller than in input file the input file is deleted. If the encode is bigger then the encoded file is deleted and the file name / path is added to the exception list
   The goal is to reclaim disk space, so the script keeps the smaller version

7. Does the files get renamed?
   
   No. The only change in the file name will be in the format, mkv gets updated to mp4. This change is because the handbrake preset outputs to mp4
   This means if you encode a file and it's orginal file name follows scene formatting, the encoded version will be incorrect. This is something I want to fix later. Here is a quick guide on proper naming https://rendezvois.github.io/miscellaneous/naming-conventions/overview/

9. How are Subtitles and Audio tracks handled?
    
   The first 3 audio tracks are retained. This is almost always the English subtitles, and in the case of Anime the English, Signs / Songs, and any OP tracks.
   As for audio tracks all tracks are retained.
   If you want to change this, you can update it on the line where HandBrake is called (HandBrakeCLI.exe). Check out the HandBrake CLI syntax here https://handbrake.fr/docs/en/latest/cli/command-line-reference.html

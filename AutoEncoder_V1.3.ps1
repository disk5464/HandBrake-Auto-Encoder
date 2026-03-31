#This script will take in a directory, figure out which files are larger than 1GB, use handbreak to reencode them, then delete the orginal file.
#Last modified: 3/31/26
#Created by: Disk5464
#Version 1.0: Inital Commit.
#Version 1.1: Added some logging and ability to provide a text file
#Version 1.2: Added an exceptions CSV to avoid processing files that will not be able to be compressed
#Version 1.3: Added the ability to add unprocessable files to the exceptions list automatically. Added a variable for the script directory to make it more portable.
#######################################################################################
#Get the working directory. This allows the script to run from any location. Then get the path to the handbrake install
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$HandbreakDirectory = "C:\Users\ADMIN\Desktop\Important Stuff\Tools\Handbreak Encoder"

#Start a transcript to track any logs
$TranscriptName = get-date -Format mm-dd-yyyy
Start-Transcript -Path "$ScriptDirectory\Logs\Log_$TranscriptName.txt"

#Change directories to where handbreak is installed
Set-Location $HandbreakDirectory

#######################################################################################
#Set an array of the directories that need to be checked. 
$DirectoriesToEncode = @("Y:\Library\Anime NAS", "Y:\Library\TV NAS")

#Import the list of expections
$ExpectionsListCSV = "$ScriptDirectory\Exceptions List.csv"
$expectionsList = Import-Csv -Path $ExpectionsListCSV

#######################################################################################
foreach ($Directory in $DirectoriesToEncode)
{
    #Get all of the files that need to be compressed
    $FilesToCompress = Get-ChildItem -Path $Directory -Recurse -File -filter "*.mkv" | Where-Object { $_.Length -gt 1GB } 

    #Foreach file that needs to be encoded 
    foreach ($file in $FilesToCompress)
    {
        #Check to make sure th file is not on the exceptions list
        if($file.fullname -notin $expectionsList."File Name")
        {
            #Set a variable for the output name
            Write-Host "Encoding" $file.Fullname
            $parts = $file.Name -split '\.'
            $OutFileNameBase = if ($parts.Length -gt 1) { $parts[0..($parts.Length-2)] -join '.' } else { $file.Name }

            #Set the output FDQN with the new file name
            $FDQNOutName = $file.DirectoryName  + "\" + $OutFileNameBase + ".mp4"
            
            #Try to encode the file.
            try {./HandBrakeCLI.exe --input $file.FullName --output $FDQNOutName --preset="Fast 1080p30" --subtitle 1,2,3 --keep-subname --all-audio }
            catch {Write-Host "Error Encoding $($file.Fullname)" -ForegroundColor Red}

            #Try and delete the orginal file
            try { 
                if( $file.length -gt (get-childitem -path $FDQNOutName).length)
                {
                    write-host "Deleting the source file $($file.FullName)" -ForegroundColor Green
                    Remove-item -Path $file.FullName
                }
                else {
                    write-host "New file is larger than the orginal, deleting the new file $($FDQNOutName)" -ForegroundColor Yellow
                    Remove-item -Path $FDQNOutName

                    #Create a new object and add it to the exception list
                    $Outobject = [pscustomobject]@{
                        "File Name" = $file.FullName
                        "Root Directory" = $file.DirectoryName
                        "File Size (MB)" = [Math]::Round( ((get-childitem -path $file.FullName).length / 1024 /1024), 2)
                        "File Size (GB)" = [Math]::Round( ((get-childitem -path $file.FullName).length / 1024 /1024 /1024), 2)
                    }
                    
                    #Add the file info to the exceptions list CSV
                    $Outobject | Export-Csv -Path $ExpectionsListCSV -Append -NoTypeInformation
                }
            }
            catch { Write-Host "Error deleteing the source or new file $($file.FullName)" -ForegroundColor Red }
        }
        else {Write-Host "$($File.name) is on the exceptions list and will not be processed."}
    }
}

#######################################################################################
Stop-Transcript
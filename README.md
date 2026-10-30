# IMO11
_Windows 11 **I**n **M**y **O**pinion_

> [!CAUTION]
> Read all `Write-Output` and comments before blindly use this project!
> I made it following my personal taste and requirements.
> IMO this is not a properly debloater!

> [!WARNING]
> This project was only tested with Windows 11 Enterprise LTSC 2024 (index 1).
> If you want to use another image comment out the following line:
> ```powershell
>Set-WindowsEdition -Path "$ScratchDisk\scratchdir" -Edition 'IoTEnterpriseS'
> ```

This project was born as a (private) fork of [`tiny11`](https://github.com/ntdevlabs/tiny11builder.git). However, due to the number of changes I've made, it can no longer really be considered a fork.

1. Add the Latest Cumulative Update (LCU) to the image and WinPE if there's a `.msu` file in `LCU` folder.
   Visit [Windows 11 Update History](https://support.microsoft.com/en-US/servicing/os/windows-11/2024/09/windows-11-version-24h2-update-history) to see which updates are available for your Windows image.
2. Properly remove Microsoft Edge using `DISM`.
3. Completely remove every disabled feature, including its payload.
4. Remove the default wallpapers and screensavers.
5. Remove the 32-bit versions of Notepad and PowerShell ISE.
6. Remove the Microsoft Kernel Debugger Network Adapter (NDIS 6.20 Miniport).
7. Some `SystemApps` are not registered during specialize phase.
   - For example, Legacy Print Dialog is restored!
8. Apply a lot of **custom tweaks**.
   - A custom theme is automatically loaded during Active Setup.
   - Disable every service related to Xbox.
   - Completely disable automatic updates and upgrades.
   - Disable the lock screen through Group Policy.
   - Prevent Windows Update from automatically downloading drivers.
   - Customize keys and values for some software (e.g., Windows PhotoViewer, 7-Zip, etc.).
   - ...
 9. Improve privacy and disable more telemetry.
 10. Run a custom WinPE script to format and partition the disk, then install Windows.
 11. Remove useless file from ISO and update boot files bootmgr/efisys.bin from `install.esd`.
 12. Active and set a default password for built-in Administrator account.
> [!WARNING]
> Change password in `unattend.xml`
> ```xml
><UserAccounts>
>    <AdministratorPassword>
>        <Value>put here your password</Value>
>        <PlainText>true</PlainText>
>    </AdministratorPassword>
></UserAccounts>
> ```
 14. When desktop appears, run `finalize.bat` to complete installation.
 15. Restore F8 and F11 functionalities during Windows boot.

There are also two important improvements.
1. During OOBE, the ZDP and NDUP pages are skipped.
2. Customize `SetupLogoff.ps1` to run a PowerShell script before logoff from defaultuser0.
   - For example, switch the first local account from Administrator to standard!

## TODO

- [ ] Examine `.inf` files

<details>
<summary>Edited README from <code>tiny11</code></summary>

# tiny11builder
*Scripts to build a trimmed-down Windows 11 image - now in **PowerShell**!*

## Introduction :
Tiny11 builder, now completely overhauled. <br> After more than a year of no updates, tiny11 builder is now a much more complete and flexible solution - one script fits all. Also, it is a steppingstone for an even more fleshed-out solution.

This is a script created to automate the build of a streamlined Windows 11 image, similar to tiny10.
The script has also been updated to use DISM's recovery compression, resulting in a much smaller final ISO size, and no utilities from external sources.
Also included is an unattended answer file, which is used to bypass the Microsoft Account on OOBE and to deploy the image with the `/compact` flag.
It's open-source, **so feel free to add or remove anything you want!** Feedback is also much appreciated.

---

## ⚠️ Script versions:
- **tiny11maker.ps1** : The regular script, which removes a lot of bloat but keeps the system serviceable. You can add languages, updates, and features post-creation.

## Instructions:
1. Download Windows 11 from the [Microsoft website](https://www.microsoft.com/software-download/windows11) or [Rufus](https://github.com/pbatard/rufus)
2. Mount the downloaded ISO image using Windows Explorer.
3. Open **PowerShell 5.1** as Administrator. 
5. Change the script execution policy :
```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
```
> Using `-Scope Process` you keep your original policy intact as this change only lasts for the current PowerShell session. 

6. Start the script :
```powershell
C:/path/to/your/tiny11/script.ps1 -ISO <letter> -SCRATCH <letter>
``` 
> You can see of the script by running the `get-help` command.

6. Select the drive letter where the image is mounted (only the letter, no colon (:))
7. Select the SKU that you want the image to be based.
8. Sit back and relax :)
9. When the image is completed, you will see it in the folder where the script was extracted, with the name tiny11.iso

---

## What is removed:
<table>
  <tbody>
    <tr>
      <th>Tiny11maker</th>
    </tr>
    <tr>
      <td>
        <ul>
          <li>Clipchamp</li>
          <li>News</li>
          <li>Weather</li>
          <li>Xbox</li>
          <li>GetHelp</li>
          <li>GetStarted</li>
          <li>Office Hub</li>
          <li>Solitaire</li>
          <li>PeopleApp</li>
          <li>PowerAutomate</li>
          <li>ToDo</li>
          <li>Alarms</li>
          <li>Mail and Calendar</li>
          <li>Feedback Hub</li>
          <li>Maps</li>
          <li>Sound Recorder</li>
          <li>Your Phone</li>
          <li>Media Player</li>
          <li>QuickAssist</li>
          <li>Internet Explorer</li>
          <li>Tablet PC Math</li>
          <li>Edge</li>
          <li>OneDrive</li>
		      <li>WinRE</li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

---

## Known issues:
- You might have to update Winget before being able to install any apps, using Microsoft Store.
- Outlook and Dev Home might reappear after some time. This is an ongoing battle, though the latest script update tries to prevent this more aggressively.
- If you are using this script on arm64, you might see a glimpse of an error while running the script. This is caused by the fact that the arm64 image doesn't have OneDriveSetup.exe included in the System32 folder.

---

## Features to be implemented:
- ~~disabling telemetry~~ (Implemented in the 04-29-24 release!)
- ~~more ad suppression~~ (Partially implemented in the 09-06-25 release!)
- improved language and arch detection

And that's pretty much it for now!

</details>



# Troll_Extract

Using a folder with BaroTroll data and a folder with RuggedTroll data, get barometrically corrected level data from the exported .zip files using 

```
Output_data <- Troll_Extract(Baro_folder = "Example_data/Zip/Baro", 
                              Level_folder = "Example_data/Zip/Level",
                              corrections_csv = "Example_data/priddo_corrections.csv")
```

* Troll_Functions.R contains the function
* Working_Example.R is a working example demonstrating how it can be implemented


To Do:
[ ] Change main function to have "corrections" as an optional feature
[ ] Gap filling for missing data
[ ] Function for stilling well applications
[ ] Make the whole thing into more of a package-like set-up as we will be using this on multiple projects...
[ ] If using as package - make option for removing last three lines (as with Jo's files)
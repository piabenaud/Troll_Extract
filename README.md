# Troll_Extract

Using a folder with BaroTroll data and a folder with RuggedTroll data, get barometrically corrected level data from the exported .zip files using 

```
Output_data <- Troll_Extract(Baro_folder = "Example_data/Zip/Baro", 
                              Level_folder = "Example_data/Zip/Level",
                              corrections = corrections)
```

* Troll_Extract_Function.R contains the function
* Working_Example.R is a working example demonstrating how it can be implemented
* Troll_Extract_Long.R is a step-by-step version of the function, as it is a little black box


To Do:
[ ] apply level corrections - suspect this is going to be an application by application function
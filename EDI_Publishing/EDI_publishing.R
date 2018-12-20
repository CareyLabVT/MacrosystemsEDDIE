### How to publish Macrosystems EDDIE modules with EDI ####

# (install and) Load EMLassemblyline #####
# install.packages('devtools')
# library(devtools)

# install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

## Step 1: Make a new directory in this GitHub folder (EDI_Publishing) for your module files ####
  # e.g., '/Macrosystems_EDDIE_Module_1_Climate_Change_Effects_on_Lake_Temperatures'

## Step 2: Move final copies of module files into the directory ####
  # This includes all instructional materials (Word, PPT), saved as PDF, and the zip folder of
  # student module files (e.g., lake_climate_change.zip, which includes R script, csv files, etc.)
  # The instructional materials PDFs will end up getting zipped together in their own folder

## Step 3: Write a README file for (a) instructional materials and (b) student module files
  # The README files describe the contents of each zip folder, and is based on tables prepared
  # as part of the EDI_metadata_template. Save as Word and PDF

## Step 4: Zip all instructional materials (with README) and add module files README to zip folder
  # You should now have two zip folders; one called 'instructional_materials.zip' and the other 
  # is the name as used in the module (e.g., 'lake_climate_change.zip')

## Step 5: Prepare metadata file templates using the EMLassemblyline::import_templates() command
  # Note: 'import_templates' command currently (Dec. 2018) only works for data products that include 
  # table-based data files (e.g., .csv). To prepare module metadata files, manually copy the
  # following metadata file templates from a previous module directory:
    # - abstract.txt
    # - additional_info.txt
    # - bounding_boxes.txt (for modules, use site of module development, not site of modeled lakes)
    # - intellectual_rights.txt (we use CCBY)
    # - keywords.txt (EDIT THIS FILE IN EXCEL; see LabKeywords.txt for Carey Lab-specific keywords)
    # - methods.txt
    # - personnel.txt (EDIT THIS FILE IN EXCEL)
  # Edit each of these files for your current module upload, by copying and pasting the relevant
  # information from the EDI_metadata_template you prepared

  # Before saving, check that the contents of each .txt file do not include any non-allowed characters by going to:
  # https://pteo.paranoiaworks.mobi/diacriticsremover/, pasting your text, and clicking remove diacritics.

  # After saving each file, make sure it is closed.

## Step 6: Obtain a package.id. Go to the EDI staging environment (https://portal-s.edirepository.org/nis/home.jsp),
  # then login using one of the Carey Lab usernames and passwords. 

  # Select Tools --> Data Package Identifier Reservations and click "Reserve Next Available Identifier"
  # A new value will appear in the "Current data package identifier reservations" table (e.g., edi.123)
  # Make note of this value, as it will be your package.id below

## Step 7: Make EML metadata file using the EMLassemblyline::make_eml() command
# For modules that contain only zip folders, modify and run the following 
# ** double-check that all files are closed before running this command! **
make_eml(path = "/Users/KJF/Desktop/R/MacrosystemsEDDIE/EDI_Publishing/Macrosystems_EDDIE_Module_1_Climate_Change_Effects_on_Lake_Temperatures",
         dataset.title = "Macrosystems EDDIE Module 1: Climate Change Effects on Lake Temperatures",
         zip.dir = c("instructor_materials.zip",
                     "lake_climate_change.zip"),
         zip.dir.description = c("This zip folder contains materials for instructors to teach the Macrosystems EDDIE 
                                 module in their classroom. See README file for file types and descriptions",
                                 "This zip folder contains materials for students to implement the Macrosystems EDDIE 
                                 module in RStudio. See README file for file types and descriptions"),
         temporal.coverage = c("2017-06-30", "2018-12-19"),
         maintenance.description = "completed", 
         user.id = "ccarey",
         affiliation = 'EDI',
         package.id = "edi.270.1") # Put your package.id here, followed by .1 (for 1st version)

## Step 8: Check your data product! Return to the EDI staging environment (https://portal-s.edirepository.org/nis/home.jsp),
  # then login using one of the Carey Lab usernames and passwords. 

  # Select Tools --> Evaluate/Upload Data Packages, then under "EML Metadata File", choose your metadata (.xml) file
  # (e.g., edi.270.1.xml), check "I want to manually upload the data by selecting files on my local system", then click Upload.

  # Now, Choose File for each file within the data package (e.g., each zip folder), then click Upload. Files will upload and 
  # your EML metadata will be checked for errors. If there are no errors, your data product is now published! If there were errors,
  # click the link to see what they were, then fix errors in the xml file. Note that each revision results in the 
  # xml file increasing one value (e.g., edi.270.1, edi.270.2, etc). Re-upload your fixed files to complete the evaluation
  # check again, until you receive a message with no errors.

## Step 9: PUBLISH YOUR DATA! Reserve a package.id for your error-free data package. Go to the EDI Production environment (https://portal.edirepository.org/nis/home.jsp)
  # and login using the ccarey (permanent) credentials. 

  # Select Tools --> Data Package Identifier Reservations and click "Reserve Next Available Identifier"
  # A new value will appear in the "Current data package identifier reservations" table (e.g., edi.123)
  # This will be your published package.id

  # Rename your error-free xml file with your published package id. This id should end in .1 (e.g., edi.123.1)

  # Select Tools --> Evaluate/Upload Data Packages, then under "EML Metadata File", choose your metadata (.xml) file
  # (e.g., edi.123.1.xml), check "I want to manually upload the data by selecting files on my local system", then click Upload.

  # Now, Choose File for each file within the data package (e.g., each zip folder), then click Upload. Files will upload and 
  # your EML metadata will be checked for errors. Since you checked for and fixed errors in the staging environment, this 
  # should run without errors, and your data product is now published! 

  # Click the package.id hyperlink to view your final product! HOORAY!
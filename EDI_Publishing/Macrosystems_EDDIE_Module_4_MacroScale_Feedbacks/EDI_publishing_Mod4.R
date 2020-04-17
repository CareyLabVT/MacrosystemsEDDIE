### How to publish Macrosystems EDDIE modules with EDI ####

# (install and) Load EMLassemblyline #####
install.packages('devtools')

devtools::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

## Step 1: Make a new directory in this subfolder (EDI_Publishing) for module files ####
  # e.g., '/Macrosystems_EDDIE_Module_2_Cross_Scale_Interactions'

## Step 2: Move final copies of all module files into the directory ####
  # This includes all instructional materials (Word, PPT) and the zip folder of
  # student module files (e.g., cross_scale_interactions.zip, which includes R 
  # script, csv files, nml files, etc.)
  # Save a copy of each instructional materials file as a PDF by the same name. 
  # These PDFs will end up getting zipped together in their own folder, called
  # "Instructor_materials PDFs"

## Step 3: Create README files in Word #### 
  # Create one README file in Word each for (a) instructional materials
  # (e.g., instructor_materials_README) and (b) files used to run the module 
  # (e.g., lake_climate_change_README) [n=2 README.docx files total]. 
  # The README files describe the contents of each zip folder, and are based on 
  # tables prepared as part of the EDI_metadata_template. Look at the previous
  # modules for templates for each of these README files. You will need to add 
  # "text/x-rsrc" as the entity for GLM nml files in the column, CSVs are known
  # file entity types so those rows can be blank.
  # Save each file in both Word and PDF format.

## Step 4: Zip all instructional materials #### 
  # Zip all instructional materials (with instructor_materials_README.pdf) into
  # one folder (instructor_materials.zip).
  # Add the module files README (e.g., lake_climate_change_README.pdf) to the 
  # zip folder of files used to run the module.
  # You should now have two zip folders; one called 'instructional_materials.zip' 
  # and the other is the name as used in the module (e.g., 'lake_climate_change.zip')
  # Be mindful that Mac users will embed hidden .DS_store files into the zip folders,
  # so good to check with PC users to see if a hidden file is in there.

## Step 5: Prepare metadata file templates ####
  # Prepare metadata file templates using the EMLassemblyline::import_templates() 
  # command. **Note:** 'import_templates' command currently (Dec. 2018) only works 
  # for data products that include table-based data files (e.g., .csv). To 
  # prepare module metadata files, manually copy the following metadata file 
  # templates from a previous module directory (e.g., the Module 1 EDI folder):
    # - start with the metadata template word doc and then populate for all of the text files, which include:
    # - abstract.txt
    # - intellectual_rights.txt (we use CCBY); won't be altered
    # - keywords.txt (EDIT THIS FILE IN EXCEL; see LabKeywords.txt for Carey 
                      # Lab-specific keywords) and also http://vocab.lternet.edu/vocab/vocab/index.php
                      # https://environmentaldatainitiative.org/resources/five-phases-of-data-publishing/phase-3/controlled-vocabularies/
                      # if there is not a word in the existing vocabularies, make it:
                      # "carey lab controlled vocabulary"
    # - methods.txt
    # - personnel.txt (EDIT THIS FILE IN EXCEL) Author order in the citation is in the order that 'creators' are listed in this file
  # Edit each of these files for your current module upload, by copying and 
  # pasting the relevant information from the EDI_metadata_template you prepared

  # Before saving, check that the contents of each .txt file do not include any 
  # non-allowed characters by going to: https://pteo.paranoiaworks.mobi/diacriticsremover/, 
  # pasting your text, and clicking remove diacritics. copy and paste that text back into the .txt file.

  # After saving each file, make sure it is closed.

## Step 6: Obtain a package.id. ####
  # Go to the EDI staging environment (https://portal-s.edirepository.org/nis/home.jsp),
  # then login using one of the Carey Lab usernames and passwords. 

  # Select Tools --> Data Package Identifier Reservations and click 
  # "Reserve Next Available Identifier"
  # A new value will appear in the "Current data package identifier reservations" 
  # table (e.g., edi.123)
  # Make note of this value, as it will be your package.id below
 
## Step 7: Make EML metadata file using the EMLassemblyline::make_eml() command ####
  # For modules that contain only zip folders, modify and run the following 
  # ** double-check that all files are closed before running this command! **

# You will need to modify the following lines to match your current module: 
  # path: set to your computer's FULL file path!
  # dataset.title: Update to current module
  # zip.dir: Change the name of the module files zip folder
  # temporal.coverage: Update the dates
  # package.id: enter the ID you obtained in Step 6

sim_folder <- getwd()

make_eml(path = sim_folder,
         dataset.title = "Macrosystems EDDIE Module 4: Macro-Scale Feedbacks",
         other.entity = c("instructor_materials.zip",
                          "macroscale_feedbacks.zip"),
         other.entity.name = c("instructor_materials", "macroscale_feedbacks"),
         other.entity.description = c("This zip folder contains materials for instructors to teach the Macrosystems EDDIE 
                                 module in their classroom. See README file for file types and descriptions",
                                 "This zip folder contains materials for students to implement the Macrosystems EDDIE 
                                 module in RStudio. See README file for file types and descriptions"),
         temporal.coverage = c("2019-04-01", "2020-04-15"),
         # keep geographic site as Derring for all MS EDDIE modules
         geographic.description = c("The Department of Biological Sciences at Virginia Tech is located in Blacksburg, Virginia, USA"),
         geographic.coordinates = c('37.229596', '-80.424863', '37.22854', '-80.426228'), #N, E, S, W
         maintenance.description = "Completed", 
         user.id = "ccarey",
         user.domain = 'EDI',
         package.id = "edi.4.1") # Put your package.id here, followed by .1 (for 1st version)

## Step 8: Check your data product! ####
  # Return to the EDI staging environment (https://portal-s.edirepository.org/nis/home.jsp),
  # then login using one of the Carey Lab usernames and passwords. 

  # Select Tools --> Evaluate/Upload Data Packages, then under "EML Metadata File", 
  # choose your metadata (.xml) file (e.g., edi.270.1.xml), check "I want to 
  # manually upload the data by selecting files on my local system", then click Upload.

  # Now, Choose File for each file within the data package (e.g., each zip folder), 
  # then click Upload. Files will upload and your EML metadata will be checked 
  # for errors. If there are no errors, your data product is now published! 
  # If there were errors, click the link to see what they were, then fix errors 
  # in the xml file. 
  # Note that each revision results in the xml file increasing one value 
  # (e.g., edi.270.1, edi.270.2, etc). Re-upload your fixed files to complete the 
  # evaluation check again, until you receive a message with no errors.

## Step 9: PUBLISH YOUR DATA! ####
  # Reserve a package.id for your error-free data package. 
  # NEVER ASSIGN this identifier to a staging environment package.
  # Go to the EDI Production environment (https://portal.edirepository.org/nis/home.jsp)
  # and login using the ccarey (permanent) credentials. 

  # Select Tools --> Data Package Identifier Reservations and click "Reserve Next 
  # Available Identifier". A new value will appear in the "Current data package 
  # identifier reservations" table (e.g., edi.518)
  # This will be your PUBLISHED package.id

  # In the make_eml command below, change the package.id to match your 
  # PUBLISHED package id. This id should end in .1 (e.g., edi.518.1)

  # ALL OTHER entries in the make_eml() command should match what you ran above,
  # in step 7

make_eml(path = "sim_folder",
         dataset.title = "Macrosystems EDDIE Module 4: Macro-Scale Feedbacks",
         other.entity = c("instructor_materials.zip",
                          "macroscale_feedbacks.zip"),
         other.entity.name = c("instructor_materials", "macroscale_feedbacks"),
         other.entity.description = c("This zip folder contains materials for instructors to teach the Macrosystems EDDIE 
                                 module in their classroom. See README file for file types and descriptions",
                                      "This zip folder contains materials for students to implement the Macrosystems EDDIE 
                                 module in RStudio. See README file for file types and descriptions"),
         temporal.coverage = c("2019-04-01", "2020-04-15"),
         # keep geographic site as Derring for all MS EDDIE modules
         geographic.description = c("The Department of Biological Sciences at Virginia Tech is located in Blacksburg, Virginia, USA"),
         geographic.coordinates = c('37.229596', '-80.424863', '37.22854', '-80.426228'), #N, E, S, W
         maintenance.description = "Completed", 
         user.id = "ccarey",
         user.domain = 'EDI',
         package.id = "edi.503.1") # Put your package.id here, followed by .1 (for 1st version) - RESERVED BY AGH ON 04-17-20

  # Once your xml file with your PUBLISHED package.id is Done, return to the 
  # EDI Production environment (https://portal.edirepository.org/nis/home.jsp)

  # Select Tools --> Preview Your Metadata, then upload your metadata (.xml) file 
  # associated with your PUBLISHED package.id. Look through the rendered 
  # metadata one more time to check for mistakes (author order, bounding box, etc.)

  # Select Tools --> Evaluate/Upload Data Packages, then under "EML Metadata File", 
  # choose your metadata (.xml) file associated with your PUBLISHED package.id 
  # (e.g., edi.518.1.xml), check "I want to manually upload the data by selecting 
  # files on my local system", then click Upload.

  # Now, Choose File for each file within the data package (e.g., each zip folder), 
  # then click Upload. Files will upload and your EML metadata will be checked for 
  # errors. Since you checked for and fixed errors in the staging environment, this 
  # should run without errors, and your data product is now published! 

  # Click the package.id hyperlink to view your final product! HOORAY!
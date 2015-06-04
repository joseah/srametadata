get_raw_metadata <- function(run_accession = NULL, 
                             sample_accession = NULL, 
                             experiment_accession = NULL, 
                             study_accession = NULL,
                             submission_accession = NULL,
                             db_con){
    
    md <- list(
        run_accession = run_accession, 
        sample_accession = sample_accession, 
        experiment_accession =  experiment_accession, 
        study_accession = study_accession,
        submission_accession = submission_accession
    )

   labs <- names(md)
   md<- lapply(seq_along(md), function(i){
        if(length(md[[i]])){
            query <- paste0("SELECT ", paste(names(md), collapse = ", ") ,
                            " FROM sra WHERE ", names(md)[[i]] ,
                            " IN ('", paste(md[[i]], collapse = "', '"), "');")
           dbGetQuery(db_con, query)
    
        }
    }
    )
   names(md) <- labs
   
   runacc <- Reduce(intersect,lapply(md,"[[",1))
   
   query  <- paste0("SELECT * FROM sra WHERE
                   run_accession IN ('", paste(runacc, 
                                               collapse = "', '"), "');")
   md <- dbGetQuery(db_con, query)
   if(nrow(md)){
       return(md)
   }else{
       return(NA)
   }
   
}


# library('srametadata')
# setwd("/home/joseah/Documents/jeff_leek_lab/github/SRAmetadata")
# 
# sqlfile <- file.path('.', 'SRAmetadb.sqlite')
# 
# # Create connection
# conn <- dbConnect(SQLite(),sqlfile)
# 
# get_raw_metadata(run_accession = c("DRR023427", "SRR946066", "ERR204978"), 
#                  experiment_accession = "SRX329581", 
#                  sample_accession = c("SRS465599","DRS014276"),
#                  study_accession = "SRP028344",
#                  submission_accession = "SRA096347", db_con = conn)



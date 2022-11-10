#' @title Evaluation Utility Function 
#' @description This function generates a textual and graphical report of the selected variables.
#' @param dataset Data set.
#' @param dictionary Data dictionary.
#' @param sex.split When TRUE, split reports by the field named 'Sex'.
#' @param sex.name Name of the Sex field.
#' @param dataset.na Data set with missing values set to NA.
#' @param h.level Header level for pandoc function.
#' @return NULL, called for its side effects.
#' @export
#' @importFrom graphics boxplot
#' @importFrom stats addmargins
#' @importFrom utils head
#' @importFrom purrr map

eval_function <- function(dataset, dictionary, sex.split = FALSE, sex.name = NULL, dataset.na, h.level=2){
  # Input:
  #   dataset = phenotype data frame
  #   dictionary = row from the data dictionary for the selected trait
  trait <- as.character(dictionary$VARNAME)
  pandoc.header(paste0(trait," - ",dictionary$TYPE),level=h.level)
  # Print information from the data dictionary
  row.names(dictionary) <- NULL
  pander(dictionary[ , c(1, 2, 5, 6, 7)],
         caption=paste0(trait, " information from the codebook"), style = "rmarkdown")
  # Extract the minimum and maximum values for this trait
  range_dictionary<-c(dictionary$MIN,dictionary$MAX)
  # The number of the column containing the selected trait
  ind<-which(names(dataset)==dictionary$VARNAME)
  if (sum(names(dataset)==dictionary$VARNAME) == 0) {
    stop(paste0("ERROR: ", dictionary$VARNAME, " not found in the data set"))
  }

  if (grepl("integer", dictionary$TYPE)) {
    if (isTRUE(all(dataset[,ind] == floor(dataset[,ind])))) {
      cat(paste0("Check passed: ",trait," is integer TYPE and all integers"),"\n")
    } else {
      cat(paste0("ERROR: ",trait," is integer TYPE but not all integers"),"\n")
    }
  }

  if (dictionary$TYPE=='decimal'){
    # Summary table
    pander(summary(dataset[,ind]),caption=paste0('Summary of ',trait), style = "rmarkdown")
    # Histogram
    print(ggplot(data=dataset.na,aes_string(trait)) + 
            geom_histogram(aes(fill=!!quote(..count..))) + 
            labs(title=trait,x=paste0(trait,"(",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")")) )     # Density plot
    print(ggplot(data=dataset.na,aes_string(trait)) + 
            geom_density() + 
            labs(title=trait,x=paste0(trait,"(",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")")) )
    # Boxplot
    boxplot( dataset.na[,ind],
             horizontal=TRUE,
             xlab=paste0(trait," (",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")"))
    if (sex.split ==TRUE) {
        if (trait != sex.name) {
      # Summary split by Sex
      # print(cat("\n\nSummary of ",trait, " split by Sex\n"))
      pander(dataset %>%
               split(eval(parse(text=paste0(".$",sex.name)))) %>%
               map(~summary(eval(parse(text=paste0(".$",trait))))),caption=paste0('Summary of ',trait,' split by ', sex.name), style = "rmarkdown" )
      # Histogram facetted by Sex
      print(ggplot(data=dataset.na,aes_string(trait)) + 
              geom_histogram(aes(fill=!!quote(..count..))) + 
              labs(title=paste0(trait,' split by ', sex.name),x=paste0(trait,"(",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")")) + 
              facet_grid(. ~ eval(parse(text=sex.name))) )
      # print(cat("\n\n Density next?\n"))
      print(ggplot(data=dataset.na,aes_string(trait)) +
              geom_density() +
              facet_grid(. ~ eval(parse(text=sex.name))) +
              labs(title=trait,x=paste0(trait,"(",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")")) )
      # Boxplot
      boxplot( dataset.na[,ind] ~ eval(parse(text=paste0("dataset$",sex.name))),
               horizontal=TRUE,
               ylab = sex.name,
               xlab=paste0(trait," (",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")"))
        }
    }
  }
  else {
    if (grepl("encoded", dictionary$TYPE)) {
      # Find unique values
      dictionary_values <- dictionary[grep('VALUES', names(dictionary))]
      unique_levels <-
        dictionary_values[which(!is.na(dictionary_values) &
                                  (dictionary_values != ""))]
      row.names(unique_levels) <- NULL
      # Table of unique values in the data dictionary
      pander(unique_levels, caption = paste0(trait, " levels from the codebook"))
      # Check if the unique values in the dataset match the unique values in the code book
      ul <- data.frame(levels = t(unique_levels))
      ul.sep <- ul %>% 
        separate(levels, c("code", "value"), sep = "=")
      pander(
        table(unique(dataset[, ind]) %in% ul.sep$code),
        caption = paste0(trait, ": unique data values in the set of codes")
      )
      ul.sep$found <- ul.sep$code %in% unique(dataset[, ind])
      pander(ul.sep,
             caption = paste0(trait, ": code book levels found in the dataset"))
      # Table of trait values
      tb <- table(dataset[, ind], useNA = "always")
      # If there are less than 25 trait values, make a table
      if (length(tb) < 25) {
        pander(addmargins(tb), caption =
                 as.character(dictionary$VARNAME))
      } else {
        # Otherwise print out a smaller table of 25 elements
        pander(tb[1:25], caption =
                 paste0(as.character(dictionary$VARNAME),": first 25 values"))
      }
      ul.d <- data.frame(data.value = unique(dataset[, ind]), found.in.code.book = NA)
      rownames(ul.d) <- NULL
      ul.d$found.in.code.book <- unique(dataset[, ind]) %in% ul.sep$code
      if (nrow(ul.d) < 25) {
        pander(ul.d, caption = paste0(trait, ": data values found and not found in code book"))
      } else {
        ul.d.tmp <- ul.d[ul.d$found.in.code.book==TRUE, ,drop=FALSE]
        rownames(ul.d.tmp) <- NULL
        pander(ul.d.tmp, caption = paste0(trait, ": data values found in code book"))
      }
    } else {
      # Table
      pander(head(table(dataset[, ind], useNA = "always"), 50), caption =
               as.character(dictionary$VARNAME))
    }
    # Bar plot
    print(ggplot(data = dataset.na, aes(eval(parse(text = trait)))) + 
            geom_bar() + 
            labs(title = trait, x = trait))
    if (grepl("decimal", dictionary$TYPE)) {
      # Density plot
      print(
        ggplot(data = dataset.na, aes_string(trait)) + 
          geom_density() + 
          labs(title = trait, x = paste0(trait, "(", as.character(dictionary$UNITS[dictionary$VARNAME==trait]), ")")
        )
      )
      # Boxplot
      boxplot( dataset.na[,ind],
               horizontal=TRUE,
               xlab=paste0(trait," (",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")"))
    }
    if (sex.split == TRUE) {
      if (trait != sex.name) {
      table1 <- table(eval(parse(text=paste0("dataset$",sex.name))), dataset[, ind], useNA = "always")
      rownames(table1)[is.na(rownames(table1))] <- "Missing"
      colnames(table1)[is.na(colnames(table1))] <- "Missing"
      if (ncol(table1) < 25) {
        pander(addmargins(table1),
               caption = paste0(as.character(dictionary$VARNAME), ' split by ', sex.name),
               style="rmarkdown")
      } else {
        # Otherwise print out a smaller table of 25 elements
        pander(table1[ ,1:25], caption =
                 paste0(as.character(dictionary$VARNAME)," split by ", sex.name,": first 25 values"),
                        style="rmarkdown")
      }

      print(
        ggplot(data = dataset.na, aes(eval(parse(text = trait)))) + 
          geom_bar() + 
          labs(title = paste0(trait, ' split by ', sex.name), x = trait) + 
          facet_grid(. ~ eval(parse(text=sex.name))))
      print(ggplot(data=dataset.na,aes_string(trait)) +
              geom_density() +
              facet_grid(. ~ eval(parse(text=sex.name))) +
              labs(title=trait,x=paste0(trait,"(",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")")) )
      # Boxplot
      boxplot( dataset.na[,ind] ~ eval(parse(text=paste0("dataset$",sex.name))),
               horizontal=TRUE,
               ylab = sex.name,
               xlab=paste0(trait," (",as.character(dictionary$UNITS[dictionary$VARNAME==trait]),")"))
      }
    }
  }
  # List out of range values
  if (!is.factor(dataset[, ind])) {
    flagged <-
      dataset[which(dataset[, ind] < range_dictionary[1] |
                      dataset[, ind] > range_dictionary[2]), , drop = FALSE]
    row.names(flagged) <- NULL
    if (nrow(flagged) > 0) {
      pander(
        unique(flagged[, ind]),
        caption = paste0('ERROR: Out of range values for ', trait),
        style = "rmarkdown"
      )
    }
  } else {
    pander(
      data.frame(levels = levels(dataset[, ind])),
      caption = paste0('Levels for the factor ', trait),
      style = "rmarkdown"
    )
  }
  # List records with missing values
  if (sum(is.na(dataset[, ind])) > 0) {
    flagged <- dataset[is.na(dataset[, ind]),]
    row.names(flagged) <- NULL
    cat("\n\n-\nThere are ", sum(is.na(dataset[, ind])), " missing values for ", trait, "\n")
    # pander(head(flagged[,ind,drop=FALSE]), caption=paste0('Missing values for ',trait), style = "rmarkdown" )
  } else {
    cat("\n\n-\n", trait, "has no missing values.\n")
  }

  if (sum(is.na(dataset.na[, ind])) > 0) {
    flagged <- dataset.na[is.na(dataset.na[, ind]),]
    row.names(flagged) <- NULL
    cat("\n\n-\nThere are ", sum(is.na(dataset.na[, ind])), " missing values for ", trait, " after mapping missing codes to NA.\n")
    # pander(head(flagged[,ind,drop=FALSE]), caption=paste0('Missing values for ',trait), style = "rmarkdown" )
  } else {
    cat("\n\n-\n", trait, "has no missing values after mapping missing codes to NA.\n")
  }
  return(NULL)
}


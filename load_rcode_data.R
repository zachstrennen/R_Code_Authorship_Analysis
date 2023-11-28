source("rcode2txt.R")

path <- "/Users/zachstrennen/Downloads/kraken.R"
gabe_code_1 <- reformat_text_R(path, replacements)

path <- "/Users/zachstrennen/Downloads/tba_helpR.r"
gabe_code_2 <- reformat_text_R(path, replacements)

path <- "/Users/zachstrennen/Downloads/tba_interfaceR.r"
gabe_code_3 <- reformat_text_R(path, replacements)

path <- "/Users/zachstrennen/Downloads/tba_readR.r"
gabe_code_4 <- reformat_text_R(path, replacements)

path <- "/Users/zachstrennen/Downloads/tba_tidyR.r"
gabe_code_5 <- reformat_text_R(path, replacements)

path <- "~/hw4app/starwars2.R"
zach_code_1 <- reformat_text_R(path, replacements)

path <- "~/hw4app/app.R"
zach_code_2 <- reformat_text_R(path, replacements)

path <- "~/hw4app/starwars2model.R"
zach_code_3 <- reformat_text_R(path, replacements)

path <- "/Users/zachstrennen/Downloads/Sentiment-Analysis-Comp-Viz.R"
zach_code_4 <- reformat_text_R(path, replacements)

path <- "/Users/zachstrennen/Downloads/Vinyl Collection Visualizations.R"
zach_code_5 <- reformat_text_R(path, replacements)

path <- "~/hw4app/linkedin_sector_conversion.R"
code_1 <- reformat_text_R(path, replacements)

document_id <- c("text1","text2","text3","text4","text5","text6","text7","text8","text9","text10","text11")

author_id <- c(rep("gabe",4),"disputed",rep("zach",4),rep("disputed",2))

code_meta <- data.frame(document_id, author_id)

text <- c(gabe_code_1,gabe_code_2,gabe_code_3,gabe_code_4,gabe_code_5,
          zach_code_1,zach_code_2,zach_code_3,zach_code_4,zach_code_5,code_1)

code_txt <- data.frame(document_id, text)

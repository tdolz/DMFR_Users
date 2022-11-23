## Margaret Conroy pivot question ###
### 11/23/22 ##

library("tidyverse")

df <- read.csv("data/Conroydat.csv", header=T)


#I wanted to plot it and use some simple things such as boxplot. 
#I wanted to calculate mean, median, sd, se, etc. length for various groupings (years, years of certain months, males only, females only, etc.)

#First I gathered malecount, femalecount, unknown count into a new variable sexstage 
#with a value freq and got rid of the frequency column as it is not useful.  I had the following columns

df.long <-pivot_longer(df, names_to = "SexStage", values_to = "Freq", cols=MaleCount:UnknownCount)%>% select(-Frequency)


#TD: summarize by what? by trawl identifier? by location? by species? I am going to assume it's mean length by location and species,
# but in this example dataset there is only one species. 

#TD: I am not sure what your end goal is so I don't know why you need one row per observation, but let's assume that you do. 
#How do we convert frequency counts into one row per observation? This is a problem that is beyond pivot_longer
#Fortunately, tidyverse has a function called uncount() that converts frequency data into one row per observation format.

df.caseform <-uncount(df.long, Freq, .remove=F)
df.caseform <-uncount(df.long, Freq)

df.caseform <-df.long%>% group_by(Year, Location, TrawlIdentifier, SpeciesCode, SexStage)%>% summarize(obs=uncount(Freq),.groups="keep")

##
df.filt <- select(df, Length, Frequency)%>% uncount(Frequency, .remove=F)
df.filt <- select(df, Length, Frequency)%>% uncount(Frequency)

df.filt <-select(df.long, SexStage, Freq, Length)%>% uncount(Freq, .id="SexStage", .remove=F)
df.filt <-select(df.long, SexStage, Freq, Length)%>% uncount(Length, .id="SexStage")

df.filt <-select(df.long, SexStage, Freq, Length)%>% uncount(Freq, .id="Length")
df.filt <-select(df.long, SexStage, Freq, Length)%>% uncount(Length, .id="Length")

df <- uncount(freq_table, weights = n)
df

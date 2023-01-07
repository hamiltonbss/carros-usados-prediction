
#Carregando as bibliotecas
library(rvest)
library(stringr)
library(readr)

#Definindo a primeira url e buscando seu conteúdo html
main_url <- 'https://agenciautodf.com.br/busca//tipo/automovel'
Pg_1 <- read_html(main_url)

#Extraindo as classes que possuem os dados desejados dos carros
get_Pg_1 <- Pg_1 %>%
  html_nodes('.text-darken-4, .resumo') %>%
  html_text()

#removendo caracteres especiais e quebras
get_Pg_1 <- str_replace_all(get_Pg_1, "[\t]", "")
get_Pg_1 <- str_replace_all(get_Pg_1, "[\n]", "") 
get_Pg_1 <- str_replace_all(get_Pg_1, "[\r]", "")


#Definindo a URL das demais páginas utilizando regex %S

url_demais <- 'https://agenciautodf.com.br/busca//tipo/automovel/pag/%s/ordem/ano-desc/'

i = seq(2, 209, 1) #209 é a última página do site no mommento do scraping

url_demais_filled <- c(sprintf(url_demais, i))

#Extraindo novamente as classes que possuem os dados desejados dos carros
get_demais <- url_demais_filled %>%
  lapply(read_html) %>%
  lapply(html_nodes,'.text-darken-4, .resumo') %>%
  lapply(html_text)

get_demais_lista <- unlist(get_demais)

#removendo caracteres especiais e quebras
get_demais_lista <- str_replace_all(get_demais_lista, "[\t]", "")
get_demais_lista <- str_replace_all(get_demais_lista, "[\n]", "") 
get_demais_lista<- str_replace_all(get_demais_lista, "[\r]", "")


#Criando os Dataframes e exportando para csv

df1 <- as.data.frame(matrix(data=get_Pg_1, nc=6, byrow = T))
df2 <- as.data.frame(matrix(data = get_demais_lista, nc=6, byrow = T))
DadosBrutos <- rbind(df1, df2) 
colnames(DadosBrutos) <- c('modelo', 'combustivel', 'cor', 'ano', 'km', 'valor')

write_csv(DadosBrutos, 'DadosBrutos.csv')


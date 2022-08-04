library(shiny)                   # this packages is use for Shiny App
library(shinydashboard)          # this packages is use for Shiny Dashboard
library(dplyr)                   # this packages is use for data preparation (edit, remove, mutate, etc)
library(stringr)                 # all functions deal with "NA"'s and zero length vectors
library(purrr)                   # requirement packages for Functional Programming Tools
library(rlang)                   # requirement packages for Rmarkdown
library(DT)                      # interface to the JavaScript library DataTables (https://datatables.net/)
library(r2d3)                    # D3 visualization
library(DBI)                     # this packages is use for Database System (DBS)
library(dbplyr)                  # this packages is use for Database System (DBS)
library(RSQLite)                 # this packages is use for Database System (DBS)
library(tidyverse)
library(glue)
library(plotly)
library(highcharter)
library(lubridate)
library(xtable)
library(ggplot2)
library(gganimate)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

data <- read.csv("rajal.csv", stringsAsFactors = F)

#type data
wtrj_clean <- data %>% 
  mutate_at(.vars = c("ID.Kunjungan", 
                      "Nomor.RM", 
                      "Nama.RM", 
                      "Nama.Dokter", 
                      "Spesialis"),
            .funs = as.factor) %>% 
  mutate(Tgl..Masuk.Resep = ymd_hms(Tgl..Masuk.Resep),
         Tgl..Input.Medis = ymd_hms(Tgl..Input.Medis),
         Tgl..Input.Telaah.Resep = ymd_hms(Tgl..Input.Telaah.Resep),
         Tgl..Input.Persiapan.Obat.Jadi = ymd_hms(Tgl..Input.Persiapan.Obat.Jadi),
         Tgl..Input.Persiapan.Obat.Racik = ymd_hms(Tgl..Input.Persiapan.Obat.Racik),
         Tgl..Input.Pengecekan.Etiket = ymd_hms(Tgl..Input.Pengecekan.Etiket),
         Tgl..Input.Penyerahan.Obat = ymd_hms(Tgl..Input.Penyerahan.Obat),
         Bulan = months(Tgl..Input.Telaah.Resep),
         Bulan = as.factor(Bulan),
         Tanggal = day(Tgl..Input.Telaah.Resep),
         Hari = weekdays(Tgl..Input.Telaah.Resep),
         jam_telaah_resep = hour(Tgl..Input.Telaah.Resep),
         jam_resep_dokter  = hour(Tgl..Masuk.Resep),
         jam_etiket = hour(Tgl..Input.Pengecekan.Etiket),
         jam_penyerahan_obat = hour(Tgl..Input.Penyerahan.Obat),
         input_medis_resep=as.numeric(difftime(time1 = Tgl..Masuk.Resep,time2 = Tgl..Input.Medis, units = "mins")),
         Input_telaah_resep= as.numeric(difftime(time1 = Tgl..Input.Telaah.Resep, time2 = Tgl..Masuk.Resep, units = "mins")),
         pio = as.numeric(difftime(time1 = Tgl..Input.Penyerahan.Obat, time2 = Tgl..Masuk.Resep, units = "mins")),
         telaah_etiket = as.numeric(difftime(time1 = Tgl..Input.Pengecekan.Etiket, time2 = Tgl..Input.Telaah.Resep, units = "mins")),
         etiket_penyerahan = as.numeric(difftime(time1 = Tgl..Input.Penyerahan.Obat, time2 = Tgl..Input.Pengecekan.Etiket, units= "mins")),
         telaah_serah = as.numeric(difftime(time1 = Tgl..Input.Penyerahan.Obat, time2 = Tgl..Input.Telaah.Resep, units="mins"))
  ) %>% 
  distinct(ID.Kunjungan,.keep_all = T) %>% 
  filter(between(pio,0,1080) &
           between(telaah_serah,0,1080))%>%
  #Input_telaah_resep,0,1080) &
  #between(telaah_etiket,0,1080)&
  #between(etiket_penyerahan,0,1080)&
  filter(!Spesialis %in% c('UMUM','FISIOTERAPI'))
wtrj_clean <- wtrj_clean %>% 
  select(ID.Kunjungan, Nomor.RM,Nama.RM,Nama.Dokter,Spesialis,Tgl..Registrasi, Tgl..Input.Medis, Tgl..Masuk.Resep,Tgl..Input.Telaah.Resep,Tgl..Input.Persiapan.Obat.Jadi, Tgl..Input.Persiapan.Obat.Racik,Tgl..Input.Pengecekan.Etiket,Tgl..Input.Penyerahan.Obat,Bulan, Tanggal, Hari, jam_telaah_resep, jam_resep_dokter,jam_etiket, jam_penyerahan_obat, pio, telaah_etiket, etiket_penyerahan, Input_telaah_resep, input_medis_resep, telaah_serah) %>% 
  drop_na(Tgl..Masuk.Resep, Tgl..Input.Medis, Tgl..Input.Telaah.Resep, Tgl..Registrasi)  %>% 
  mutate(Hari = as.factor(Hari))

#select Spesialis
dokter_spesialist_list <- wtrj_clean %>%
  select(Spesialis) %>% 
  distinct()

#select Dokter
dokter_list <- wtrj_clean %>%
  select(Nama.Dokter) %>% 
  distinct()

#select Month
month_list <- as.list(1:12) %>%
  set_names(month.name)
month_list$`All Year` <- 99


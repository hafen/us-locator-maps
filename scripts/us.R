library(usmap)
library(ggplot2)
library(magick)
library(dplyr)

plot_usmap(regions = "states", color = "white", fill = "gray")

statelist <- statepop
statelist$pop_2015 <- NULL

sts <- us_map(regions = "states")

for (i in 1:nrow(statelist)) {
  tmp <- dplyr::filter(sts, abbr == statelist$abbr[i])

  p <- plot_usmap(regions = "states",
    color = "white", fill = "lightgray", values = "val", size = 0.25) +
    geom_polygon(data = tmp, aes(x, y, group = group),
    fill = "#E15759", color = "#E15759", size = 0.25) +
    theme(plot.margin = margin(0, 0, 0, 0),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA))

  f <- paste0("thumbs/admin1/US/", statelist$fips[i], ".png")
  ggsave(f, p, width = 10, height = 1, bg = "transparent")
}

ff <- list.files("thumbs/admin1/US/", full.names = TRUE)
for (f in ff) {
  tmp <- image_read(f)
  image_write(image_trim(tmp), path = f, format = "png")
}

countylist <- countypop
countylist$pop_2015 <- NULL

cts <- us_map(regions = "counties")

for (i in 1:nrow(countylist)) {
  cc <- countylist$abbr[i]
  message(cc)
  clist <- countylist$fips[countylist$abbr == cc]
  tmp <- dplyr::filter(cts, fips == countylist$fips[i])

  p <- plot_usmap(regions = "counties", include = clist,
    color = "white", fill = "lightgray", values = "val", size = 0.25) +
    geom_polygon(data = tmp, aes(x, y, group = group),
      fill = "#E15759", color = "#E15759", size = 0.25) +
    theme(plot.margin = margin(0, 0, 0, 0),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA))

  f <- paste0("thumbs/admin2/US/", countylist$fips[i], ".png")
  ggsave(f, p, width = 10, height = 1, bg = "transparent")
}

ff <- list.files("thumbs/admin2/US/", full.names = TRUE)
for (f in ff) {
  tmp <- image_read(f)
  image_write(image_trim(tmp), path = f, format = "png")
}

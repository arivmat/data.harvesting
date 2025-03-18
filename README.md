 # Book Cover Color Analysis

> By Maria Carda & Andrea Rivera

![Static Badge](https://img.shields.io/badge/R_code-%23276DC3?logo=R&labelColor=white&logoColor=%23276DC3) ![Static Badge](https://img.shields.io/badge/HTML-grey?logo=htmx&logoColor=gray&labelColor=white) ![Static Badge](https://img.shields.io/badge/CSS-blue?logo=htmx&logoColor=gray&labelColor=white) ![Static Badge](https://img.shields.io/badge/tidyverse-R_package-%23276DC3?logo=Tidyverse&logoColor=black&labelColor=white&color=%23276DC3)

## At a glance

This project analyzes the dominant colors in book covers across different authors and categories. The goal is to uncover patterns in color usage by genre, author, and source (*Goodreads* & *Casa del Libro*) using data visualization and clustering techniques.

## Project Overview

The Book Cover Color Analysis project consists of the following components:

1.  <u>Data Processing & Color Extraction</u>: Extraction of dominant colors from book covers, processing the data to identify the most frequently used colors.
2.  <u>Data Visualization</u>: Utilization of ggplot2 to create heatmaps and color grids, showcasing the most prominent colors used for different authors, genres, and platforms.
3.  <u>Shiny Application</u>: Creation of an interactive user interface built with R Shiny, allowing users to explore book cover color palettes by selecting an author/genre/platform.

## Required packages

```{r}
library(ggplot2)       # data visualization
library(tidyverse)     # data manipulation, cleaning, and transformation
library(RSelenium)     # web automation and dynamic web scraping
library(rvest)         # web scraping from static web pages
library(magick)        # image processing and analysis
library(scales)        # re-scaling and formatting data
library(shiny)         # building interactive web applications
library(writexl)       # exporting processed data to Excel files for easy sharing
```

## Installation and Setup

To successfully run the project, follow these steps:

1.  Install R: Install the programming language on your machine.

2.  Install "RSelenium": this package requires a web driver and browser automation setup. It is needed to install the following outside of R:

    -   [Java](https://www.java.com/es/download/manual.jsp): Ensure that Java is installed and properly configured.
    -   [Docker](https://www.docker.com/products/docker-desktop/): Install Docker from Docker's official website.
    -   [VNC Viewer](https://www.realvnc.com/es/connect/download/viewer/): Download and install VNC Viewer from RealVNC.

3.  Setup Rselenium: following the previous installation, it is required to open docker before running the code and log in with a user. Then, run the following commands in the R terminal:

    -   docker info
    -   docker run hello-world
    -   docker pull selenium/standalone-firefox-debug:latest
    -   docker run -d -p 4449:4444 -p 5901:5900 --platform linux/amd64 selenium/standalone-firefox-debug:latest

4.  Run the application: Once all dependencies are installed and configured, the project can be run by opening R and executing the main script.

## Usage

Once the project is set up and running, users can utilize the various data processing and visualization features seamlessly. The project enables web scraping to collect book cover images and extract dominant colors, allowing for an in-depth analysis of color trends across different authors and genres. Users can explore the most frequently used colors for different authors, genres, and sources, comparing trends.

## Features

The Book Cover Analysis project offers the following features:

1.  Data Collection (`scrap_books)`: Load book metadata, including title, author, and cover image.
2.  Color Extraction (`extract_colors)`: Identify dominant colors from book cover images.
3.  Clustering & Cleaning: Group similar colors and remove duplicates.
4.  Visualization: Generate plots and applications ([shiny](https://mariacarda.shinyapps.io/data_harvesting_books/)) showing color distribution by author, webpage and category.

## Future Enhancements

Some future enhancements for the project include:

-   <u>Machine Learning Insights</u>: Use machine learning to explore correlations between cover colors, book sales, and genre popularity.
-   <u>Expanded Data Sources</u>: Extend web scraping to collect book cover data from additional sources for a more comprehensive dataset.
-   <u>Advanced Visualizations</u>: Enhance data visualization with interactive dashboards and advanced filtering options.
-   <u>NLP Integration</u>: Apply natural language processing (NLP) to analyze book descriptions and compare thematic elements with cover aesthetics.

## Conclusion

This project provides an insightful exploration of book cover color palettes, revealing how different platforms, genres, and authors use color to establish visual identity. By leveraging web scraping, data processing, and visualization techniques, the project identifies trends in book cover designs across various sources. It serves as a foundation for further research into the relationship between book design and reader engagement, with potential future enhancements including machine learning-based cover analysis and real-time data updates.

## Disclaimer

This project was built with the academic purpose of practicing data harvesting techniques. We have not and will not use this project for commercial purposes. We do not condone anyone using this code for commercial purposes. Our intention of sharing this repository is to showcase our skills.

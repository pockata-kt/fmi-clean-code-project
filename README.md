## Weather app - Clean code project

This is my project for the Clean Code course at FMI of Sofia University.
It is a simple Ruby application that collects information from various weather forecast websites (`Sinoptik` and `AccuWeather` for now) and shows the information in a dashboard.

This application is not affiliated with any of the information providers in any way. All collected data is publicly accessible.

## Technical documentation

Can be found [here](docs/).

## Running the application

### Prerequisites

 - Ruby (tested on 2.5.0)
 - Bundler (tested on 1.16.2)

### Installing dependencies

To install the necessary dependencies run:

```shell
bundle install
```

### Running

```shell
ruby dashboard.rb
```

## Testing and style guidelines

To run the unit tests:

```shell
rspec
```

To run checks for style guidelines:

```shell
rubocop
```

## TO-DO:
- [x] Add a dashboard to show the collected information
- [x] Use inheritance to reduce code duplication
- [ ] Add error handling
- [ ] Write unit tests

# Bitmap Editor Technical Test

This is a ruby implementation of technical test called `Bitmap Editor` which can be found [here][1].
The code in this repo is mainly divided into small/simple classes and each class own its responsibilities, errors, constants, state and behaviour as follows:

+ [`BitmapEditor`][8] is responsible for proxing users input to the Bitmap object, mainly using a command parser object.

+ [`Command`][9] is responsible for parsing the user input and encapsulate the command parts (Type, coordinates and colour) and it also validates the user input to make sure that a user is trying a valid command with valid params.

+ [`Bitmap`][10] is responsible for handling the bitmap structure and different operations to be applied on bitmap like (initialize new bitmap, color a given pixel, color a given vertical/horizontal segment, etc.). `Bitmap` is also handling how a bitmap should be shown on a user terminal.

+ [`Pixel`][11] is just a simple class structure to define allowed colours that a pixel can accept and how a pixel can be represented on a user terminal.

This project is following `TDD` so [specs][12] are always set before feature coding.

# Setup & Run

This project is using:

+ ruby 2.3.1
+ bundler gem to install all required gems that are listed in [Gemfile][2].
+ rspec gem as the tests framework. Config can be found in [.rspec][3].
+ rubocop gem as a main codeing style guide. Config can be found in [.rubocop.yml][4].
+ [Docker][5] to run the application without any dependecies using docker engine.

## Using Docker

[Install Docker Engine][6] on your machine to be able to follow these steps.

run `docker --version` to make sure that docker is installed and running successfully. You should get a message like `Docker version 1.12.3, build 6b644ec`. Now you follow these steps:

+ Build docker image from source
```shell
docker build . -t bitmap_editor:latest_git_commit_sha
```
where `latest_git_commit_sha` is the git current checked out git commit SHA.

+ Run the application on a docker container
```shell
docker run -it bitmap_editor:target_git_commit_sha "ruby runner.rb"
```

+ Run tests on a docker container
```shell
docker run -it bitmap_editor:target_git_commit_sha "rspec"
```

## Without Docker

You need to install the dependecies first, follow these steps to install all required dependencies using [`RVM`][7]:

+ Install RVM
```shell
$ curl -sSL https://get.rvm.io | bash -s stable
```

+ Install/Use ruby 2.3.1 and create a gemset for this project
```shell
$ rvm use ruby-2.3.1@bitmap_editor --create
```

+ Install bundler gem
```shell
$ gem install bundler
```

+ Install gems listed in Gemfile
```shell
$ bundle install
```

+ Run application
```shell
$ ruby runner.rb
```
+ Run tests
```shell
$ rspec
```

[1]: https://gist.github.com/soulnafein/8ee4e60def4e5468df2f
[2]: https://github.com/tareksamni/bitmap_editor/blob/master/Gemfile
[3]: https://github.com/tareksamni/bitmap_editor/blob/master/.rspec
[4]: https://github.com/tareksamni/bitmap_editor/blob/master/.rubocop.yml
[5]: https://github.com/tareksamni/bitmap_editor/blob/master/Dockerfile
[6]: https://docs.docker.com/engine/installation/
[7]: https://rvm.io/
[8]: https://github.com/tareksamni/bitmap_editor/blob/master/app/bitmap_editor.rb
[9]: https://github.com/tareksamni/bitmap_editor/blob/master/app/command.rb
[10]: https://github.com/tareksamni/bitmap_editor/blob/master/app/bitmap.rb 
[11]: https://github.com/tareksamni/bitmap_editor/blob/master/app/pixel.rb
[12]: https://github.com/tareksamni/bitmap_editor/tree/master/spec
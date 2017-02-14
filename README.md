# Global Names Crossmap Web Interface

A web-based GUI for [gn_crossmap]. The [gn_crossmap] Ruby gem allows
comparison of one list of names against another.

[![Continuous Integration Status][ci-svg]][ci]
[![Code Climate][code-svg]][code]
[![Test Coverage][test-svg]][test]
[![Dependency Status][deps-svg]][deps]

## Testing

* install docker
* install docker-compose
* run

```bash
docker-compose up
docker-compose run app rake
```

## Development

We recommend to use docker-compose for development

To prepare the system (if you run it first time or
there was an update in the code) go to the project's
root and then

```bash
docker-compose down # if it is running

sudo chown -R `whoami` # for linux only (Windows, Mac do it for you)

docker-compose build
```

Start it all:

```bash
docker-compose up
```

Point your browser to `http://0.0.0.0:9292`

For testing purposes you can use [this csv file][csv-file]

To stop it run

```bash
docker-compose down
```


[ci-svg]: https://circleci.com/gh/GlobalNamesArchitecture/gn_crossmap_web.svg?style=shield
[ci]: https://circleci.com/gh/GlobalNamesArchitecture/gn_crossmap_web
[code-svg]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap_web/badges/gpa.svg
[code]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap_web
[test-svg]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap_web/badges/coverage.svg
[test]: https://codeclimate.com/github/GlobalNamesArchitecture/gn_crossmap_web
[deps-svg]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap_web.svg
[deps]: https://gemnasium.com/GlobalNamesArchitecture/gn_crossmap_web
[Guard]: https://github.com/guard/guard
[gn_crossmap]: https://github.com/GlobalNamesArchitecture/gn_crossmap
[csv-file]: https://raw.githubusercontent.com/GlobalNamesArchitecture/gn_crossmap_web/master/spec/files/wellformed-semicolon.csv

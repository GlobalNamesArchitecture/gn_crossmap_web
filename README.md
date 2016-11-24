# Global Names Crossmap Web Interface

A web-based GUI to `gn_crossmap` gem. This gem allows comparison of one list of
names against another.

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

We recommend to use docker container for development

To start the system use

```bash
docker-compose up
```

To stop it run

```bash
docker-compose down
```

### Automatic compiling of Elm scripts

If you are changing Elm scripts and want to compile them automatically
start [Guard] in a separate terminal window with

```bash
docker-compose run app bundle exec guard
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


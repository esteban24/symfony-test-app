# Symfony-test-app

Symfony web app created for using Github actions for creating a CI pipeline

## Develop

Install dependencies with `composer`:

```shell
$ composer install
```

Start development web server locally (using `symfony` CLI):
```shell
$ symfony server:start
```

Then navigate to [http://localhost:8000/](http://localhost:8000/) or [http://127.0.0.1:8000/](http://127.0.0.1:8000/)

## Testing

Execute command:
```shell
$ vendor/bin/phpunit
```

## Versioning

For versioning just update `version.txt` before merging to `master` branch. 

## Changelog

You can check the latest changes in the [CHANGELOG.md](CHANGELOG.md) file
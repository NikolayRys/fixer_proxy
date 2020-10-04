# Test task for Freska

## Description
Microservice that proxies Fixer API endpoint for historical currency conversion rates.

## To start up
```
bundle install
ruby server.rb
```
It starts at default Sinatra port `http://localhost:4567/`

## Usage
Endpoint that mimics [Fixer API Historic endpoint](https://fixer.io/documentation).
Accept date in YYYY-MM-DD format.
Optionally allows to pass the list of required currency symbols.
If not provided, defaults to all known 168 symbols.

Example:
`http://localhost:4567/2020-10-04?symbols=USD,AUD,CAD,PLN,MXN`

## Notes
* Root URL returns short description with a usage example.
* EUR symbol is excluded from both HTTP calls and DB storage, since it never changes.
* Amount of cache hits is logged to console.
* To reset DB: `rm cache.db`

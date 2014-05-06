DNSimple-DynDNS bridge
======================

This little app is meant to be hosted on Heroku and used as a custom endpoint
for [dynamic DNS service on DD-WRT
routers](http://www.dd-wrt.com/wiki/index.php/Dynamic_DNS) running `inadyn`.
DNSimple does not expose an `inadyn`-compatible API, so this implements it.

The goal is for the user to configure DDNS with custom settings that point to
a URL structure similar to DNSimple's existing API. This is so that if DNSimple
suddenly implements it (unlikely, I've asked), all the user must change is the
hostname of the DDNS server.

There are two endpoints to this app:

### `/`

Going to `/` displays how to use the application, and provides some hints as to
what goes in the fields on the DD-WRT DDNS page.

### `/domains/:domain_id/records/:record_id`

This is the real business endpoint. The `domain_id` is the base domain name in
DNSimple, while the `record_id` is the numerical ID for the exact record that
you want to update when hitting this endpoint.

You must pass your email address and *domain* API key as username and password.
The `myip` query parameter to the URL contains the IP used to update, and is
automatically added by `inadyn`.

License
-------

MIT. Look it up.


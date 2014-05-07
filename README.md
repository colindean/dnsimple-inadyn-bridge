DNSimple-inadyn bridge
======================

This little app is meant to be hosted on Heroku and used as a custom endpoint
for [dynamic DNS service on DD-WRT
routers](http://www.dd-wrt.com/wiki/index.php/Dynamic_DNS) running `inadyn`.
DNSimple does not expose an `inadyn`-compatible API, so this implements it.

The goal is for the user to configure DDNS with custom settings that point to
a URL structure similar to DNSimple's existing API. This is so that if DNSimple
suddenly implements it (unlikely, I've asked), all the user must change is the
hostname of the DDNS server.

Intention
---------

This is intended to be a web service usable by anyone.

`inadyn` does not have an option to send updates over SSL, so this app makes no
provision to enable SSL. **API keys are thus sent in plaintext from your router
to the bridge.** They are sent over SSL to DNSimple, but **are in plaintext from
your router to this app because the client does not support SSL.** There, I said
it and bolded it.

Thus, you should trust this app very little. Use it at your own risk and host it
only on systems whose owners you would trust having your domain API key for the
domain in DNSimple that you use for dynamic hostnames!

No user should ever give this app an API key for a domain that has a large
amount of traffic. E.g., if a user wants to use home.example.com as their domain,
it's better to create a second domain within DNSimple, dyn.example.com, and
simply CNAME home.example.com to home.dyn.example.com. That way, no one can mess
with anything else that's in example.com records.

Using
-----

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

External Links
--------------

* [Dyn API Return Codes](http://dyn.com/support/developers/api/return-codes/)
* [DNSimple Domains/Records API docs](http://developer.dnsimple.com/domains/records/)
* [inadyn readme/manpage](http://inatech.eu/inadyn/readme.html)

Known working configurations
----------------------------

* inadyn packaged with DD-WRT v24-sp2 (04/15/13) std (SVN revision 21286)
* inadyn packaged with DD-WRT v24-sp2 (10/10/09) vpn (SVN revision 13064)

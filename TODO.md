* methods like Yt::Account.new(params = {}) should use HashWithIndifferentAccess
* add canonical_url to Resource, then use it in promo

* once in a while, Google fails with 500 error and just retrying after some
seconds fixes it, so we should retry every 500 at least

* find by url (either video or channel or.. playlist)
* Google accounts?
* ENV support

* operations like subscribe that require authentication should not fail if
called on Yt::Channel without auth but, similarly to account, show the prompt
or ask for the device code

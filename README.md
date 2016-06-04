discourse-cookie-token-domain
=======================

A Discourse plugin to add an additional cookie token at the second-level domain, for site/s wanting to do cross-site credential management.

This essentially allows an install at forums.example.com to create a cookie token valid at *.example.com

The cookie contains basic information about a user and a hmac


Cookie content is encode in base64. After decode64 you will have :
```
{
    "username":"CapitaineJohn",
    "user_id":2,"avatar":"/user_avatar/forum.teambac.fr/capitainejohn/{size}/117_1.png",
    "group":"[VIP]",
    "sha256_d": "",
    "hmac":"e40575e0f828bcf91b5e30c174dfa4399c72a5acbb32b2a483f8fce42798b1ac"
}
```

The hmac is set with the secret key set in the admin panel

![plugin settings](https://i.gyazo.com/8e428c62a48bdfecfc36718807281e10.png)

---

### Check if user is logged ?

In your webiste at location www.domain.com or *.domain.com follow this step :

* decode the cookie in base64
* get the sha256_d value
* compare the sha256_d to check if user is connected :

```
if hmac === hmac(sha256,key, sha256_d):
    print 'user if logged'
else:
    print 'user not logged'
```


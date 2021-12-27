discourse-cookie-token-domain
=======================

A Discourse plugin to add an additional cookie token at the second-level domain, for site/s wanting to do cross-site credential management.

This essentially allows an install at forums.example.com to create a cookie token valid at *.example.com

The cookie contains basic information about a user and a hmac


Cookie content is encode in base64. After decode64 you will have :
```
{
    "username":"CapitaineJohn",
    "user_id":2,"avatar":"/user_avatar/forum.example.com/bonclay/{size}/117_1.png",
    "group":"[VIP]",
    "sha256_d": "lROIoUjQVMv1vMThVCMbhS1YehFE4S3aMVKN9Rg2Z7M=",
    "hmac":"e40575e0f828bcf91b5e30c174dfa4399c72a5acbb32b2a483f8fce42798b1ac"
}
```

The hmac is set with the secret key set in the admin panel

![plugin settings](https://i.gyazo.com/8e428c62a48bdfecfc36718807281e10.png)

---

### Check if user is logged ?

In your webiste at location www.domain.com or *.domain.com follow this step :

* get the cookie `logged_in`
* urldecode the cookie
* decode the cookie in base64 : `logged_in`
* urldecode the cookie
* set a sha256 of the data
* compare the sha256 to check if user is connected :

```
if hmac === hmac(sha256, key, data):
    print 'user if logged'
else:
    print 'user not logged'
```

#### Example in PHP

```php
$cookie = urldecode($_COOKIE["logged_in"]);
$cookie = base64_decode($cookie);
$cookie = urldecode($cookie);

$user_infos = json_decode($cookie);

$array_hash = array(
    'username' => $user_infos->username,
    'user_id' => $user_infos->user_id,
    'avatar' => $user_infos->avatar,
    'group' => $user_infos->group
);

$hash_test = hash('sha256', json_encode($array_hash, JSON_UNESCAPED_SLASHES));

$test = hash_hmac('sha256',$hash_test,'QALS3FtxwKNj39tb');

if ($test !== $user_infos->hmac) {
    return 'user not logged';
}
```

#### Example in Node.js
```javascript
const crypto = require('crypto');

// Get the value of the `logged_in` cookie from where ever makes sense
// in your application. The browser should send it to your backend.
// For this example, it is hard-coded.
const valueOfLoggedInCookie =
  'eyJ1c2VybmFtZSI6ImhvbGxvd3ZlcnNlIiwidXNlcl9pZCI6MSwiYXZhdGFyIjoiL3VzZXJfYXZhdGFyL2Rpc2N1c3MuaG9sbG93dmVyc2UuY29tL2hvbGxvd3ZlcnNlL3tzaXplfS8zXzIucG5nIiwiZ3JvdXAiOm51bGwsImhtYWMiOiI5Njk1ZDdhNDk2ZTBiMTMwZWY1OTI2YjI1NjMyMWUzYjI0YjM5ZWJkNjZjODk3ZTdiNjc0YWVhNjRiZDkyZTdkIn0%3D';

const uriDecodedPayload = decodeURIComponent(valueOfLoggedInCookie);
const base64DecodedBuffer = Buffer.from(uriDecodedPayload, 'base64');
const preJsonPayload = JSON.parse(base64DecodedBuffer.toString());
const jsonPayload = {
  username: preJsonPayload.username,
  user_id: preJsonPayload.user_id,
  avatar: preJsonPayload.avatar,
  group: preJsonPayload.group,
};
const payloadSha = crypto
  .createHash('sha256')
  .update(JSON.stringify(jsonPayload))
  .digest('hex');

const signed = crypto
  .createHmac('sha256', 'QALS3FtxwKNj39tb')
  .update(payloadSha)
  .digest('hex');

if (signed === preJsonPayload.hmac) {
  console.log('User is logged in');
} else {
  console.log('User is not logged in');
}
```

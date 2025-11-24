'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "9a24614057a0b244d37b87811372bfe5",
"assets/AssetManifest.bin.json": "e4e8e5cd30388c31985843a4a6bb9b77",
"assets/FontManifest.json": "9f2b45bee8da4a4995195a7a45f5cad3",
"assets/fonts/MaterialIcons-Regular.otf": "a2f88de046a0b1dc5d55bd53498a0503",
"assets/NOTICES": "57a95455005fa73b16ab2cff57d350ca",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_lucide/lib/fonts/lucide.ttf": "2c47bd2592254f122e3e79569dc1b18e",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/public/animated-exercise-instruction-illustration-step-by.jpg": "600a5984391bc57155a40459d4f0f613",
"assets/public/apple-icon.png": "734ce6c878789fcd5843e8a7963e0756",
"assets/public/balanced-healthy-meal-plate-nutrition-illustration.jpg": "16f23626efaaf506f09bbf6b99463e14",
"assets/public/body-comparison-progress-visualization-illustratio.jpg": "bdfb1f02febfb3ec284f76b2288ff90b",
"assets/public/body-silhouette-athletic.jpg": "c06ab1e97b8bd42219f0f76f612161f2",
"assets/public/body-silhouette-front.jpg": "9d799f0fd72872acdae76a318548f680",
"assets/public/body-silhouette-side.jpg": "546b04d9396dc2097cdcc6277a1ee327",
"assets/public/fitness-pulse-heartbeat-icon-white-transparent.jpg": "57c0d3cf7702b96839c141f3ccc89e6e",
"assets/public/human-body-silhouette-side-view-athletic-fit-trans.jpg": "902207b0f7a79ed44f5eb71a24cb4454",
"assets/public/human-body-silhouette-side-view-current-weight-tra.jpg": "8303a7766a6b5208a79e562f585ec67d",
"assets/public/icon-dark-32x32.png": "abd5ebe9e287ca0a89f4fd3da2b5cf9c",
"assets/public/icon-light-32x32.png": "53426c910bcab7d3e5213cc64aa1b2c5",
"assets/public/icon.svg": "6e5d88c5f7e97d26ac4ad47e703bf9de",
"assets/public/motivational-strength-icon-transparent.jpg": "119b01b72e7148ab6ab46e36f283ff3b",
"assets/public/person-doing-glute-bridge-exercise-illustration.jpg": "cb19ed08c30123f6f24eedfe0ddc0335",
"assets/public/person-doing-lunges-exercise-illustration.jpg": "8013011537c7722fe5751e9322f50568",
"assets/public/person-doing-squats-exercise-illustration.jpg": "84ec4a248b1bbb67e7e3e54917c293e9",
"assets/public/placeholder-logo.png": "95d8d1a4a9bbcccc875e2c381e74064a",
"assets/public/placeholder-logo.svg": "1e16dc7df824652c5906a2ab44aef78c",
"assets/public/placeholder-user.jpg": "7ee6562646feae6d6d77e2c72e204591",
"assets/public/placeholder.jpg": "1e533b7b4545d1d605144ce893afc601",
"assets/public/placeholder.svg": "35707bd9960ba5281c72af927b79291f",
"assets/public/two-body-silhouettes-one-lean-one-muscular-fitness.jpg": "e8e894fe8b6dd23ca7331ff307b373fa",
"assets/public/workout-icon.jpg": "43d15370df190e7c93454548d899e343",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "8f255cbef48302c15f8ad65a983d7969",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "6fe57a35993344b4bbbf9ae39334285a",
"/": "6fe57a35993344b4bbbf9ae39334285a",
"main.dart.js": "7bde519e3c7d46c3121f4d127564706f",
"manifest.json": "91d7e1bb970a7dd2b8db1824385e4824",
"version.json": "a6826738faf7de42002fb9e19ac87771"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

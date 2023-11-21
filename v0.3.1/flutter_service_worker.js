'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "e6dab9bae3682c7be33f64cfee3a5645",
"index.html": "33a8cc4227374a7a4182441582d1b348",
"/": "33a8cc4227374a7a4182441582d1b348",
"main.dart.js": "4f901cbf2ed40e9004ef905d259277fb",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "7721f75d05bf245b6ddc15e236d95503",
"assets/AssetManifest.json": "6053939f5115c61f7c8c276b89b743ea",
"assets/NOTICES": "b530dfb50707d20efe40fe28f6ee089d",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "4fdf8130ca47591f1dffd8596bf3fc31",
"assets/fonts/MaterialIcons-Regular.otf": "2ca9e8940f8f48f1286e503601e96640",
"assets/assets/images/coins/10.png": "64215cc3c796e101d0e3aa8fd86baf7a",
"assets/assets/images/coins/25.png": "841c3ee60a7080499879c14dbe5fd016",
"assets/assets/images/coins/5.png": "db5d18c3fa138c7625313bbe5923717d",
"assets/assets/images/coins/50.png": "cce2692b367707185c0d0e9697fea79b",
"assets/assets/images/coins/coin.png": "494719aff8d323c646f27b8f3d10709f",
"assets/assets/images/items/8.png": "b68c636a821e093881b1ee286f1cccbb",
"assets/assets/images/items/9.png": "282a988aa3fa3055673c3003096d9174",
"assets/assets/images/items/14.png": "5b68cadb1f5ac15d478b5fe5efaa29c6",
"assets/assets/images/items/15.png": "06c7f0f9bb87f2b212f38692c119c456",
"assets/assets/images/items/17.png": "e650b16646add5eb32c3edc5e9b2950c",
"assets/assets/images/items/16.png": "8c2b87780a469f81324b3b5323c42a64",
"assets/assets/images/items/12.png": "896363d0f9f74c2f9df95de4184d6b4f",
"assets/assets/images/items/13.png": "efbb08957b8d03aadf52c4771245b200",
"assets/assets/images/items/11.png": "cbc48bfc726aadb2571d0917664bb65c",
"assets/assets/images/items/10.png": "442f7ef5d6cba0a9095514a435453ba4",
"assets/assets/images/items/18.png": "4851d93b17c43232146c251a5eaaabd4",
"assets/assets/images/items/19.png": "f58185e2734439f9167f7ef1c9a07911",
"assets/assets/images/items/4.png": "f9b1a62f97be4ed8969081dc37aac923",
"assets/assets/images/items/5.png": "4682e1cb87c8c4c59ef2e6cc8f65df05",
"assets/assets/images/items/7.png": "4886eef9ad765f298d59a5d8bd165dad",
"assets/assets/images/items/6.png": "7822938ae627e074d9140cc7ba84f9fc",
"assets/assets/images/items/2.png": "3f15cb043742b3b0bf3b7de580c5a25c",
"assets/assets/images/items/3.png": "e08c8cdc9b72fb4d14b2c92449b106ca",
"assets/assets/images/items/1.png": "cdf3d7050ddc9a44452fc9f60bb9336b",
"assets/assets/images/items/0.png": "68f54f0255f5f9d06c6e0b05e4631fac",
"assets/assets/images/decor/gmu_logo_cropped.png": "77c59ae7072e7d3e618d70eaea21f010",
"assets/assets/images/decor/gmu_clock_tower.png": "fe6279da5726bf7948fec95f1c9eeb45",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
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

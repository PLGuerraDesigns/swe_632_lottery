'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "4e8bfa620c10e6ecf130e65a58cb7b02",
"index.html": "a522b3fdf15ddcd67c1e19f5e9d0ca1e",
"/": "a522b3fdf15ddcd67c1e19f5e9d0ca1e",
"main.dart.js": "5c1b56f0dfb6503e608ba599d9dd2dd0",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"favicon.png": "4576917dac68d41be2e9d6793f63d167",
"manifest.json": "7721f75d05bf245b6ddc15e236d95503",
"icon/Icon-192.png": "ff0132de12466986c89ba955d2de1e42",
"icon/Icon-maskable-192.png": "ff0132de12466986c89ba955d2de1e42",
"icon/Icon-maskable-512.png": "ea0ce9cedf6152ce3b357bc5d66a15a4",
"icon/Icon-512.png": "ea0ce9cedf6152ce3b357bc5d66a15a4",
"assets/AssetManifest.json": "5f5e357727aa76ce64efe0fb2bc779fa",
"assets/NOTICES": "ef8d26f1de041a92a8843a6028e04afd",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "3fec2ade7f1dc519316c0f7c3c92a106",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/AssetManifest.bin": "b400a3eeba20f71c676eaa348ffcf6c4",
"assets/fonts/MaterialIcons-Regular.otf": "f301f4ba5aaf341e8f1b640470542f5b",
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
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
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

'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "29e18219a128a6d4a7cfecfd14811b50",
"index.html": "a123cdb7d51e35938a12996ebc9952e9",
"/": "a123cdb7d51e35938a12996ebc9952e9",
"main.dart.js": "3ceae9f2b2849e8505b94b7f200a5ce5",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "7721f75d05bf245b6ddc15e236d95503",
"assets/AssetManifest.json": "dc544fa74f23dda5407b858f77baabc0",
"assets/NOTICES": "b530dfb50707d20efe40fe28f6ee089d",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "cfbfbe14e7cc49616d3b641d331d2918",
"assets/fonts/MaterialIcons-Regular.otf": "2ca9e8940f8f48f1286e503601e96640",
"assets/assets/images/decor/gmu_logo_cropped.png": "77c59ae7072e7d3e618d70eaea21f010",
"assets/assets/images/decor/gmu_clock_tower.png": "fe6279da5726bf7948fec95f1c9eeb45",
"assets/assets/items/0.jpeg": "373157c1e149b7c0fc9a36d2aa43d3d6",
"assets/assets/items/1.jpeg": "c070b59b9551b499a1675e3a4ce12c9d",
"assets/assets/items/8.png": "4557ba1b196e7f2120476db0418fc7b6",
"assets/assets/items/9.png": "45ae2fdb01d2a33ea83b37d20e1280db",
"assets/assets/items/14.png": "8dce08ee03c7022f8ae082d12f93201d",
"assets/assets/items/15.png": "8806e18fe9076f69bd47471a10630ea5",
"assets/assets/items/17.png": "56d792c896f63561fb780167ca3ca440",
"assets/assets/items/16.png": "cdf3d7050ddc9a44452fc9f60bb9336b",
"assets/assets/items/6.jpeg": "ce546a55c3e46ce25fc3b56b9831015f",
"assets/assets/items/7.jpeg": "9fd5bc79c0cee4d1748afd02f0f51a6f",
"assets/assets/items/12.png": "3a8bd6e0ff4cb918994940c9bfb13ed5",
"assets/assets/items/13.png": "25b242171434d4e91a2a75b4d7af6b06",
"assets/assets/items/11.png": "a4de72adb89af3c7f8bda98898cd1417",
"assets/assets/items/10.png": "4741e5348cd60b744ab2443d5ef6f1ea",
"assets/assets/items/4.jpeg": "c3b2db057e68fc25fdd82ee6645a9930",
"assets/assets/items/5.jpeg": "55fd30381fdf0d1fda33595fb5f56d38",
"assets/assets/items/18.png": "d2e3bbc6158f650245f2396211047a0c",
"assets/assets/items/19.png": "b077089d6d0b53129a98d7f79da75b03",
"assets/assets/items/2.jpeg": "77038ca01331281df329bd7a4e4ae357",
"assets/assets/items/4.png": "70a2d1247f49165ed511e64bfec03969",
"assets/assets/items/5.png": "8c00fbbceb054509add34f1f76ff3475",
"assets/assets/items/7.png": "f7acabe32a43707dd9c849850368a732",
"assets/assets/items/6.png": "8456956e6dedf5e6aff9e8e45f6a2691",
"assets/assets/items/2.png": "3227dd642a4cc9883cfd26e530b51f5b",
"assets/assets/items/3.png": "18b0f6cbaae5033b9924596dabbf93e5",
"assets/assets/items/1.png": "6e2803cf80f9271aede230a8783af18f",
"assets/assets/items/0.png": "4682e1cb87c8c4c59ef2e6cc8f65df05",
"assets/assets/items/3.jpeg": "6d3f94ab38d8b242d2cf2e234f3416c3",
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

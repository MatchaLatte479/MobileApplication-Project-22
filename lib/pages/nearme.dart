import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dart:convert';

class SolarStore {
  final String name;
  final String rating;
  final String address;
  final String distance;
  final double lat;
  final double lng;

  SolarStore({
    required this.name,
    required this.rating,
    required this.address,
    required this.distance,
    required this.lat,
    required this.lng,
  });
}

class NearMePage extends StatefulWidget {
  const NearMePage({super.key});

  @override
  State<NearMePage> createState() => _NearMePageState();
}

class _NearMePageState extends State<NearMePage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _showCurrentLocation = true;
  String _selectedProvince = 'นนทบุรี';
  SolarStore? _selectedStore;

  final List<String> _provinces = [
    'กรุงเทพมหานคร',
    'นนทบุรี',
    'ปทุมธานี',
    'สมุทรปราการ',
    'ชลบุรี',
    'เชียงใหม่',
    'ภูเก็ต',
    'อื่นๆ'
  ];

  // Store data
  final List<SolarStore> _stores = [];

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  Future<void> _initializeWebViewController() async {
    // Platform-specific initialization
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams();
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'SolarStoreChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // Process the store data received from JavaScript
          final storeData = jsonDecode(message.message);
          setState(() {
            _stores.clear();
            for (var store in storeData) {
              _stores.add(SolarStore(
                name: store['name'],
                rating: store['rating'],
                address: store['address'],
                distance: store['distance'],
                lat: store['lat'],
                lng: store['lng'],
              ));
            }

            // Select the first store by default if available
            if (_stores.isNotEmpty && _selectedStore == null) {
              _selectedStore = _stores[0];
            }
          });
        },
      )
      ..addJavaScriptChannel(
        'MarkerSelectedChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // Process the selected marker/store
          final markerIndex = int.tryParse(message.message);
          if (markerIndex != null &&
              markerIndex >= 0 &&
              markerIndex < _stores.length) {
            setState(() {
              _selectedStore = _stores[markerIndex];
            });
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() => _isLoading = false);
            }
          },
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            // When page is loaded, call searchByProvince if needed
            if (!_showCurrentLocation) {
              _controller
                  .runJavaScript('searchByProvince("$_selectedProvince")');
            }
          },
          onWebResourceError: (WebResourceError error) {
            setState(() => _isLoading = false);
            print("WebView Error: ${error.description}");
          },
        ),
      )
      ..loadHtmlString(_getHtmlContent());

    // Enable hybrid composition for Android (reduces flickering)
    if (params is AndroidWebViewControllerCreationParams) {
      final AndroidWebViewController androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  String _getHtmlContent() {
    const apiKey = 'bf881d6834afa68c0afa5137ac184dac';
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <script src="https://api.longdo.com/map/?key=$apiKey"></script>
      <style>
        html, body, #map {
          height: 100%;
          margin: 0;
          padding: 0;
          overflow: hidden;
        }
        .marker-info {
          padding: 8px;
          background: white;
          border-radius: 4px;
          box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        }
      </style>
    </head>
    <body>
      <div id="map"></div>
      <script>
        // Wait for the Longdo Map API to fully load
        window.onload = function() {
          var map;
          var markers = [];
          var currentLocationMarker = null;
          var storeData = [];

          // Initialize the map
          function initMap() {
            try {
              map = new longdo.Map({
                placeholder: document.getElementById('map'),
                language: 'th',
                zoom: 15
              });
              
              // Add onClick event to the map for marker selection
              map.Event.bind('click', function(overlay) {
                if (overlay) {
                  const markerIndex = markers.indexOf(overlay);
                  if (markerIndex !== -1) {
                    // Send the selected marker index to Flutter
                    window.MarkerSelectedChannel.postMessage(markerIndex.toString());
                  }
                }
              });
              
              // After map is initialized
              if (${_showCurrentLocation} && navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showLocation, showError, {
                  enableHighAccuracy: true,
                  timeout: 5000,
                  maximumAge: 0
                });
              } else {
                searchByProvince('${_selectedProvince}');
              }
            } catch (e) {
              console.error("Error initializing map:", e);
            }
          }

          function clearMarkers() {
            try {
              if (markers.length > 0) {
                markers.forEach(marker => map.Overlays.remove(marker));
                markers = [];
              }
              
              if (currentLocationMarker) {
                map.Overlays.remove(currentLocationMarker);
                currentLocationMarker = null;
              }
              
              // Clear store data
              storeData = [];
            } catch (e) {
              console.error("Error clearing markers:", e);
            }
          }

          function addMarker(lat, lng, title, detail, storeInfo) {
            try {
              const position = {lon: lng, lat: lat}; // Correct format for Longdo
              const marker = new longdo.Marker(position, {
                title: title,
                detail: detail,
                icon: {
                  url: 'https://maps.google.com/mapfiles/ms/icons/red-dot.png',
                  offset: { x: 12, y: 12 }
                },
                weight: longdo.OverlayWeight.Top
              });
              map.Overlays.add(marker);
              markers.push(marker);
              
              // Also add to storeData array
              storeData.push(storeInfo);
              
              // Zoom to show all markers
              if (markers.length > 1) {
                // Create bounds from marker locations
                const bounds = [];
                markers.forEach(m => bounds.push(m.location()));
                map.bound(bounds);
              } else if (markers.length === 1) {
                map.location(position, true);
                map.zoom(15);
              }
            } catch (e) {
              console.error("Error adding marker:", e);
            }
          }

          function showLocation(position) {
            try {
              const center = {lon: position.coords.longitude, lat: position.coords.latitude};
              map.location(center, true);
              map.zoom(15);
              
              if (currentLocationMarker) {
                map.Overlays.remove(currentLocationMarker);
              }
              
              currentLocationMarker = new longdo.Marker(center, {
                title: 'ตำแหน่งของคุณ',
                detail: 'คุณอยู่ที่นี่',
                icon: {
                  url: 'https://maps.google.com/mapfiles/ms/icons/blue-dot.png',
                  offset: { x: 12, y: 12 }
                },
                weight: longdo.OverlayWeight.Top
              });
              map.Overlays.add(currentLocationMarker);
              
              // Add sample solar stores near current location
              addSampleStoresNearLocation(center.lat, center.lon);
            } catch (e) {
              console.error("Error showing location:", e);
            }
          }

          function showError(error) {
            console.log('Geolocation error:', error);
            // Default to Bangkok
            const defaultCenter = {lon: 100.5018, lat: 13.7563};
            map.location(defaultCenter, true);
            addSampleStoresNearLocation(defaultCenter.lat, defaultCenter.lon);
          }

          function addSampleStoresNearLocation(lat, lng) {
            try {
              // Clear previous markers
              clearMarkers();
              
              // In a real app, you would fetch these from an API
              // Here we just add some sample locations around the given coordinates
              const stores = [
                {name: 'Solar Expert', rating: '5.0', address: 'อำเภอปากเกร็ด นนทบุรี', distance: '0.5 กม.', lat: lat + 0.005, lng: lng + 0.005},
                {name: 'พลังงานแสงอาทิตย์ไทย', rating: '4.8', address: '456 ถนนรัชดาภิเษก', distance: '1.2 กม.', lat: lat - 0.003, lng: lng + 0.007},
                {name: 'ซันเพาเวอร์', rating: '4.5', address: '789 ถนนลาดพร้าว', distance: '0.8 กม.', lat: lat + 0.007, lng: lng - 0.002},
                {name: 'HUISOLARCELL', rating: '4.9', address: '321 ถนนพระราม 9', distance: '1.5 กม.', lat: lat - 0.006, lng: lng - 0.004}
              ];
              
              stores.forEach(store => {
                const storeInfo = {
                  name: store.name,
                  rating: store.rating,
                  address: store.address,
                  distance: store.distance,
                  lat: store.lat,
                  lng: store.lng
                };
                
                addMarker(
                  store.lat,
                  store.lng,
                  store.name,
                  '<div class="marker-info">' +
                    '<h4>' + store.name + '</h4>' +
                    '<p>⭐ ' + store.rating + '</p>' +
                    '<p>' + store.address + '</p>' +
                    '<p>' + store.distance + ' จากคุณ</p>' +
                  '</div>',
                  storeInfo
                );
              });
              
              // Send store data to Flutter
              window.SolarStoreChannel.postMessage(JSON.stringify(storeData));
            } catch (e) {
              console.error("Error adding sample stores:", e);
            }
          }

          window.searchByProvince = function(province) {
            try {
              console.log('Searching for province:', province);
              // In a real app, you would geocode the province to get coordinates
              // Here we use some known coordinates for demo
              const provinceCoords = {
                'กรุงเทพมหานคร': {lat: 13.7563, lng: 100.5018},
                'นนทบุรี': {lat: 13.8625, lng: 100.5145},
                'ปทุมธานี': {lat: 14.0208, lng: 100.5254},
                'สมุทรปราการ': {lat: 13.5990, lng: 100.5968},
                'ชลบุรี': {lat: 13.3611, lng: 100.9847},
                'เชียงใหม่': {lat: 18.7883, lng: 98.9853},
                'ภูเก็ต': {lat: 7.9519, lng: 98.3381},
                'อื่นๆ': {lat: 15.8700, lng: 100.9925}
              };
              
              const coords = provinceCoords[province] || provinceCoords['กรุงเทพมหานคร'];
              // Use object notation for Longdo Map coordinates
              map.location({lon: coords.lng, lat: coords.lat}, true);
              map.zoom(13);
              addSampleStoresNearLocation(coords.lat, coords.lng);
            } catch (e) {
              console.error("Error searching province:", e, province);
            }
          };
          
          // Initialize map once API is fully loaded
          setTimeout(initMap, 500);
        };
      </script>
    </body>
    </html>
    ''';
  }

  void _searchStores() {
    setState(() {
      _showCurrentLocation = false;
      _isLoading = true;
      _selectedStore = null;
    });

    // Reload the map with new settings
    _controller.loadHtmlString(_getHtmlContent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'ร้านโซล่าเซลล์ใกล้ฉัน',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Search Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedProvince,
                  decoration: InputDecoration(
                    labelText: 'จังหวัด',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: _provinces.map((String province) {
                    return DropdownMenuItem<String>(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != _selectedProvince) {
                      setState(() {
                        _selectedProvince = newValue;
                        _showCurrentLocation = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _searchStores,
                    child: const Text(
                      'ค้นหาร้าน',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _showCurrentLocation,
                      activeColor: Colors.orange,
                      onChanged: (bool? value) {
                        setState(() {
                          _showCurrentLocation = value ?? false;
                        });
                      },
                    ),
                    const Text('ใช้ตำแหน่งปัจจุบัน'),
                  ],
                ),
              ],
            ),
          ),
          // Map and Results
          Expanded(
            child: Column(
              children: [
                // Map Container
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: WebViewWidget(controller: _controller),
                        ),
                      ),
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          ),
                        ),
                    ],
                  ),
                ),
                // Selected Store Card
                if (_selectedStore != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildSelectedStoreCard(_selectedStore!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedStoreCard(SolarStore store) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${store.rating} / 5 คะแนน',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    store.address,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'เปิด 24 ชั่วโมง',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.directions),
                onPressed: () {
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

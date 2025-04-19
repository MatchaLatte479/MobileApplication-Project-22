import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class NearMePage extends StatefulWidget {
  const NearMePage({super.key});

  @override
  State<NearMePage> createState() => _NearMePageState();
}

class _NearMePageState extends State<NearMePage> {
  late final WebViewController _controller;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _showCurrentLocation = true;
  String _selectedProvince = 'กรุงเทพมหานคร';
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

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  Future<void> _initializeWebViewController() async {
    // Platform-specific initialization
    final platform = WebViewPlatform.instance;
    if (platform is WebKitWebViewPlatform) {
      WebKitWebViewPlatform.registerWith();
    } else if (platform is AndroidWebViewPlatform) {
      AndroidWebViewPlatform.registerWith();
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
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
          },
          onWebResourceError: (WebResourceError error) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadHtmlString(_getHtmlContent());

    // Enable hybrid composition for Android (reduces flickering)
    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
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
        var map = new longdo.Map({
          placeholder: document.getElementById('map'),
          language: 'th'
        });
        
        var markers = [];
        var currentLocationMarker = null;

        function clearMarkers() {
          markers.forEach(marker => map.Overlays.remove(marker));
          markers = [];
        }

        function addMarker(lat, lng, title, detail) {
          const position = new longdo.LatLon(lat, lng);
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
          
          // Zoom to show all markers
          if (markers.length > 0) {
            map.bounds(markers.map(m => m.location()));
          }
        }

        function showLocation(position) {
          const center = new longdo.LatLon(
            position.coords.latitude, 
            position.coords.longitude
          );
          map.location(center, true);
          
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
          
          // Add sample solar stores near current location (in real app, use actual API)
          addSampleStoresNearLocation(center.latitude, center.longitude);
        }

        function showError(error) {
          console.log('Geolocation error:', error);
          // Default to Bangkok
          const defaultCenter = new longdo.LatLon(13.7563, 100.5018);
          map.location(defaultCenter, true);
          addSampleStoresNearLocation(defaultCenter.latitude, defaultCenter.longitude);
        }

        function addSampleStoresNearLocation(lat, lng) {
          // Clear previous markers
          clearMarkers();
          
          // In a real app, you would fetch these from an API
          // Here we just add some sample locations around the given coordinates
          const stores = [
            {name: 'โซล่าเซลล์ เอ็กซ์เพิร์ต', rating: '5.0', address: '123 ถนนสุขุมวิท', distance: '0.5 กม.', lat: lat + 0.005, lng: lng + 0.005},
            {name: 'พลังงานแสงอาทิตย์ไทย', rating: '4.8', address: '456 ถนนรัชดาภิเษก', distance: '1.2 กม.', lat: lat - 0.003, lng: lng + 0.007},
            {name: 'ซันเพาเวอร์', rating: '4.5', address: '789 ถนนลาดพร้าว', distance: '0.8 กม.', lat: lat + 0.007, lng: lng - 0.002},
            {name: 'โซล่าฟาร์ม', rating: '4.9', address: '321 ถนนพระราม 9', distance: '1.5 กม.', lat: lat - 0.006, lng: lng - 0.004}
          ];
          
          stores.forEach(store => {
            addMarker(
              store.lat,
              store.lng,
              store.name,
              '<div class="marker-info">' +
                '<h4>' + store.name + '</h4>' +
                '<p>⭐ ' + store.rating + '</p>' +
                '<p>' + store.address + '</p>' +
                '<p>' + store.distance + ' จากคุณ</p>' +
              '</div>'
            );
          });
        }

        function searchByProvince(province) {
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
          map.location(new longdo.LatLon(coords.lat, coords.lng), true);
          addSampleStoresNearLocation(coords.lat, coords.lng);
        }

        if ($_showCurrentLocation && navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(showLocation, showError, {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
          });
        } else {
          searchByProvince('$_selectedProvince');
        }
      </script>
    </body>
    </html>
    ''';
  }

  void _searchStores() {
    setState(() {
      _showCurrentLocation = false;
      _isLoading = true;
      _controller.loadHtmlString(_getHtmlContent());
    });
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
                    setState(() {
                      _selectedProvince = newValue!;
                    });
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
              ],
            ),
          ),
          // Map and Results
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: WebViewWidget(controller: _controller),
                  ),
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
              ],
            ),
          ),
          // Bottom store list (sample)
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStoreCard(
                  'โซล่าเซลล์ เอ็กซ์เพิร์ต',
                  '5.0',
                  '123 ถนนสุขุมวิท',
                  '0.5 กม.',
                ),
                _buildStoreCard(
                  'พลังงานแสงอาทิตย์ไทย',
                  '4.8',
                  '456 ถนนรัชดาภิเษก',
                  '1.2 กม.',
                ),
                _buildStoreCard(
                  'ซันเพาเวอร์',
                  '4.5',
                  '789 ถนนลาดพร้าว',
                  '0.8 กม.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(String name, String rating, String address, String distance) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(rating),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              address,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              'ระยะทาง $distance',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
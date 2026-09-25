import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend/payment_api.dart';
import '../widgets/brand_logo.dart';

class DemoStorefrontScreen extends StatefulWidget {
  const DemoStorefrontScreen({super.key});

  @override
  State<DemoStorefrontScreen> createState() => _DemoStorefrontScreenState();
}

class _DemoStorefrontScreenState extends State<DemoStorefrontScreen> {
  final _categories = const ['All', 'Soap', 'Face Mask', 'Pickle'];
  final _products = const [
    _DemoProduct(
        'Goat Milk Soap',
        'Nourishing and gentle',
        75,
        80,
        'https://qpeimg.b-cdn.net/img_6366_result30260_1773342385985202.png?format=webp',
        'Soap',
        'goat-milk-soap/227013'),
    _DemoProduct(
        'Haldi Chandan Kesar Soap',
        'Turmeric, sandalwood and saffron',
        80,
        100,
        'https://qpeimg.b-cdn.net/img_6379_result30260_1773599763103844.png?format=webp',
        'Soap',
        'haldi-chandan-kesar-soap/227113'),
    _DemoProduct(
        'Neem Soap Combo',
        'Pack of 4 soaps, total 400 grams',
        250,
        260,
        'https://qpeimg.b-cdn.net/img_6342_result30260_1775204118100052.png?format=webp',
        'Soap',
        'neem-soap-combo-pack-of-4-soaps-total-400-grams/227640'),
    _DemoProduct(
        'Neem Tulsi Aloe Vera Soap',
        'Purifying botanical care',
        65,
        99,
        'https://qpeimg.b-cdn.net/img_6342_result30260_1773599912167215.png?format=webp',
        'Soap',
        'neem-tulsi-aloe-vera-soap/227114'),
    _DemoProduct(
        'Orange Soap',
        'Fresh citrus handmade soap',
        60,
        65,
        'https://qpeimg.b-cdn.net/img_6301_result30260_1773340160110147.png?format=webp',
        'Soap',
        'orange-soap/227012'),
    _DemoProduct(
        'Rice, Mulethi & Olive Oil Soap',
        'Brightening botanical blend',
        100,
        140,
        'https://qpeimg.b-cdn.net/img_6318_result30260_1773600736171958.png?format=webp',
        'Soap',
        'rice-mulethi-olive-oil-soap/227116'),
    _DemoProduct(
        'Rose Soap',
        'Soft floral daily care',
        70,
        75,
        'https://qpeimg.b-cdn.net/img_6384_result30260_1773339734533411.png?format=webp',
        'Soap',
        'rose-soap/227011'),
    _DemoProduct(
        'Satpara Face Mask',
        'Natural glow face pack',
        150,
        299,
        'https://qpeimg.b-cdn.net/img_7044_result30260_1774006353160026.png?format=webp',
        'Face Mask',
        'satpara-face-mask-natural-glow-face-pack/227268'),
    _DemoProduct(
        'Turmeric Pickle - 180g',
        'Traditional homemade-style pickle',
        250,
        300,
        'https://qpeimg.b-cdn.net/img_7039_result30260_1774006666151185.png?format=webp',
        'Pickle',
        'satpara-naturals-turmeric-pickle-180g/227269'),
    _DemoProduct(
        'Shea Butter Soap',
        'Deeply moisturizing handmade bar',
        80,
        120,
        'https://qpeimg.b-cdn.net/img_6349_result30260_1773600557198261.png?format=webp',
        'Soap',
        'shea-butter-soap/227115'),
  ];

  int _selectedCategory = 0;
  int _selectedTab = 0;
  String _searchQuery = '';
  final Map<String, int> _cart = {};
  final Set<String> _wishlist = {};
  bool _isSignedIn = false;

  int get _cartCount => _cart.values.fold(0, (sum, quantity) => sum + quantity);
  List<_DemoProduct> get _visibleProducts => (_selectedCategory == 0
          ? _products
          : _products
              .where((product) =>
                  product.category == _categories[_selectedCategory])
              .toList())
      .where((product) =>
          _searchQuery.isEmpty ||
          '${product.name} ${product.subtitle} ${product.category}'
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EC),
        foregroundColor: const Color(0xFF21392B),
        elevation: 0,
        titleSpacing: wide ? 48 : 16,
        title: BrandTitle(
          textColor: const Color(0xFF21392B),
          logoSize: wide ? 42 : 36,
          fontSize: wide ? 18 : 15,
        ),
        actions: [
          if (wide) ...[
            TextButton(onPressed: _scrollToProducts, child: const Text('Shop')),
            TextButton(onPressed: _showStory, child: const Text('Our story')),
            TextButton(onPressed: _showContact, child: const Text('Contact')),
          ],
          IconButton(
              onPressed: _showSearch, icon: const Icon(Icons.search_rounded)),
          IconButton(
            onPressed: _showAccount,
            icon: Icon(_isSignedIn ? Icons.person : Icons.person_outline),
            tooltip: _isSignedIn ? 'Account' : 'Sign in',
          ),
          Stack(
            children: [
              IconButton(
                  onPressed: _showCart,
                  icon: const Icon(Icons.shopping_bag_outlined)),
              if (_cartCount > 0)
                Positioned(
                    right: 5,
                    top: 5,
                    child: CircleAvatar(
                        radius: 9,
                        backgroundColor: const Color(0xFFD98E3B),
                        child: Text('$_cartCount',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)))),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _selectedTab == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      color: const Color(0xFFD98E3B),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: const Text(
                          'FIRST10  |  Get 10% off your first order',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        wide ? 48 : 18, 22, wide ? 48 : 18, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Image.network(
                              'https://qpeimg.b-cdn.net/main-home-banner30260_1773340793853797.jpg',
                              height: wide ? 300 : 310,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                  height: 310, color: const Color(0xFF3E6B4F))),
                          Positioned.fill(
                              child: Container(
                                  color: Colors.black.withValues(alpha: .22))),
                          Positioned(
                              left: wide ? 48 : 24,
                              bottom: 34,
                              right: 24,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Pure care,\nnaturally.',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 38,
                                            height: 1.05,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10),
                                    const Text(
                                        'Handmade rituals for skin that feels at home.',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    const SizedBox(height: 18),
                                    FilledButton(
                                        onPressed: _scrollToProducts,
                                        style: FilledButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor:
                                                const Color(0xFF3E6B4F),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 22, vertical: 13)),
                                        child: const Text(
                                            'Explore the collection')),
                                  ])),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          wide ? 48 : 18, 30, wide ? 48 : 18, 14),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Shop by ritual',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF21392B))),
                            TextButton(
                                onPressed: _scrollToProducts,
                                child: const Text('View all'))
                          ])),
                  SizedBox(
                      height: 46,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding:
                              EdgeInsets.symmetric(horizontal: wide ? 48 : 18),
                          itemCount: _categories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, index) => ChoiceChip(
                              label: Text(_categories[index]),
                              selected: _selectedCategory == index,
                              onSelected: (_) =>
                                  setState(() => _selectedCategory = index),
                              selectedColor: const Color(0xFF3E6B4F),
                              labelStyle: TextStyle(
                                  color: _selectedCategory == index
                                      ? Colors.white
                                      : const Color(0xFF3E6B4F),
                                  fontWeight: FontWeight.w600)))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        wide ? 48 : 18, 22, wide ? 48 : 18, 0),
                    child: _benefitStrip(wide),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          wide ? 48 : 18, 30, wide ? 48 : 18, 14),
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Shop by concern',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF21392B))))),
                  SizedBox(
                    height: 116,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 18),
                      children: const [
                        _ConcernTile('Brightening', Icons.wb_sunny_outlined,
                            Color(0xFFE9B949)),
                        _ConcernTile('Hydrating', Icons.water_drop_outlined,
                            Color(0xFF78A9C9)),
                        _ConcernTile('Clarifying', Icons.spa_outlined,
                            Color(0xFF709B72)),
                        _ConcernTile('Daily care', Icons.favorite_border,
                            Color(0xFFD98282)),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          wide ? 48 : 18, 30, wide ? 48 : 18, 16),
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Made with good things',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF21392B))))),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 18),
                      itemCount: _visibleProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: wide ? 4 : 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 18,
                          childAspectRatio: wide ? .72 : .62),
                      itemBuilder: (_, index) =>
                          _productCard(_visibleProducts[index])),
                  const SizedBox(height: 46),
                  Container(
                      width: double.infinity,
                      color: const Color(0xFF21392B),
                      padding: const EdgeInsets.all(28),
                      child: const Column(children: [
                        Text('Small-batch. Thoughtfully made.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 7),
                        Text(
                            'Virar, Maharashtra  |  connect@satparanaturals.com',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70))
                      ])),
                ],
              ),
            )
          : _selectedTab == 1
              ? _buildShopTab()
              : _selectedTab == 2
                  ? _buildWishlistTab()
                  : _buildAccountTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Shop'),
          NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Saved'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Account'),
        ],
      ),
    );
  }

  Widget _buildShopTab() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          sliver: SliverToBoxAdapter(
            child: Text('Shop all rituals',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF21392B))),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search soaps, masks, body care',
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () => setState(() => _searchQuery = ''),
                        icon: const Icon(Icons.clear)),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) => ChoiceChip(
                label: Text(_categories[index]),
                selected: _selectedCategory == index,
                onSelected: (_) => setState(() => _selectedCategory = index),
                selectedColor: const Color(0xFF3E6B4F),
                labelStyle: TextStyle(
                    color: _selectedCategory == index
                        ? Colors.white
                        : const Color(0xFF3E6B4F)),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                (_, index) => _productCard(_visibleProducts[index]),
                childCount: _visibleProducts.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                childAspectRatio: .62),
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistTab() {
    final saved =
        _products.where((product) => _wishlist.contains(product.name)).toList();
    return saved.isEmpty
        ? _emptyTab(Icons.favorite_border, 'Your saved rituals',
            'Tap the heart on a product to keep it here.')
        : GridView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: saved.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 18,
                childAspectRatio: .62),
            itemBuilder: (_, index) => _productCard(saved[index]));
  }

  Widget _buildAccountTab() => _isSignedIn
      ? _emptyTab(Icons.verified_user_outlined, 'Demo account active',
          'demo.customer@satparanaturals.com\nYour orders and preferences will live here.')
      : _emptyTab(Icons.person_outline, 'Your Satpara account',
          'Sign in to save rituals and follow your orders.',
          action: 'Sign in');

  Widget _emptyTab(IconData icon, String title, String subtitle,
      {String? action}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 54, color: const Color(0xFF3E6B4F)),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF21392B))),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black54, height: 1.5)),
            if (action != null) ...[
              const SizedBox(height: 20),
              FilledButton(onPressed: _showAccount, child: Text(action)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _benefitStrip(bool wide) {
    final benefits = [
      (Icons.eco_outlined, 'Plant-based', 'Thoughtfully sourced'),
      (Icons.handshake_outlined, 'Handmade', 'Small-batch care'),
      (Icons.local_shipping_outlined, 'Easy delivery', 'Across India'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFE8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: benefits
            .map((benefit) => Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(benefit.$1,
                          color: const Color(0xFF3E6B4F), size: 24),
                      if (wide) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(benefit.$2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF21392B))),
                              Text(benefit.$3,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _productCard(_DemoProduct product) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showProduct(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE8EFE8),
                        child: const Icon(Icons.spa_outlined,
                            size: 42, color: Color(0xFF3E6B4F)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      onPressed: () => setState(() {
                        if (_wishlist.contains(product.name)) {
                          _wishlist.remove(product.name);
                        } else {
                          _wishlist.add(product.name);
                        }
                      }),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: .9)),
                      icon: Icon(
                          _wishlist.contains(product.name)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 19,
                          color: _wishlist.contains(product.name)
                              ? Colors.redAccent
                              : null),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 11, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF21392B))),
                  const SizedBox(height: 3),
                  Text(product.subtitle,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${product.price}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16)),
                      if (product.mrp > product.price)
                        Text('₹${product.mrp}',
                            style: const TextStyle(
                                color: Colors.black45,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12)),
                      IconButton(
                          onPressed: () => _addToCart(product),
                          icon: const Icon(Icons.add_shopping_cart_rounded,
                              color: Color(0xFF3E6B4F))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(_DemoProduct product) {
    setState(() => _cart[product.name] = (_cart[product.name] ?? 0) + 1);
    _showMessage('${product.name} added to your bag.');
  }

  void _scrollToProducts() {
    setState(() => _selectedTab = 1);
  }

  void _showProduct(_DemoProduct product) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product.name),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.subtitle,
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              const Text(
                  'Handmade with plant-based ingredients for a gentle daily ritual.'),
              const SizedBox(height: 16),
              Text('₹${product.price}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 20)),
              if (product.mrp > product.price)
                Text(
                    '${((product.mrp - product.price) / product.mrp * 100).round()}% off',
                    style: const TextStyle(
                        color: Color(0xFF2E7D32), fontWeight: FontWeight.w700)),
            ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
          OutlinedButton(
              onPressed: () => launchUrl(Uri.parse(
                  'https://satparanaturals.com/product/${product.slug}')),
              child: const Text('View website')),
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _addToCart(product);
              },
              child: const Text('Add to bag')),
        ],
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(builder: (context, setSheetState) {
        final selected = _products
            .where((product) => _cart.containsKey(product.name))
            .toList();
        final total = selected.fold<int>(
            0, (sum, product) => sum + product.price * _cart[product.name]!);
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your bag ($_cartCount)',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close))
                    ]),
                if (selected.isEmpty)
                  const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Your bag is waiting for something good.')),
                ...selected.map((product) => ListTile(
                    title: Text(product.name),
                    subtitle:
                        Text('₹${product.price} x ${_cart[product.name]}'),
                    trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() => _cart.remove(product.name));
                          setSheetState(() {});
                        }))),
                if (selected.isNotEmpty) ...[
                  const Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        Text('₹$total',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800))
                      ]),
                  const SizedBox(height: 14),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startCheckout(total);
                      },
                      child: const Text('Continue to checkout')),
                ],
              ]),
        );
      }),
    );
  }

  void _showAccount() {
    if (_isSignedIn) {
      _showMessage('Signed in as demo.customer@satparanaturals.com');
      return;
    }
    showDialog<void>(
        context: context,
        builder: (_) => _DemoAuthDialog(
            onSuccess: () => setState(() => _isSignedIn = true)));
  }

  void _startCheckout(int total) {
    if (!_isSignedIn) {
      showDialog<void>(
          context: context,
          builder: (_) => _DemoAuthDialog(onSuccess: () {
                setState(() => _isSignedIn = true);
                _startCheckout(total);
              }));
      return;
    }
    final address = TextEditingController();
    showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text('Delivery details'),
                content: TextField(
                    controller: address,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        hintText: 'Full address with pincode')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back')),
                  FilledButton(
                      onPressed: () {
                        if (address.text.trim().isEmpty) return;
                        Navigator.pop(context);
                        _showPayment(total);
                      },
                      child: const Text('Continue to payment'))
                ]));
  }

  void _showPayment(int total) {
    showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text('Test payment gateway'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          'Development mode: no real money will be charged.'),
                      const SizedBox(height: 16),
                      Text('Order total  ₹$total',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800))
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  OutlinedButton(
                      onPressed: () async {
                        try {
                          final order = await PaymentApi()
                              .createOrder(amountInRupees: total);
                          if (!mounted) return;
                          Navigator.pop(context);
                          _showMessage(
                              'Razorpay test order created: ${order.id}');
                        } catch (error) {
                          if (!mounted) return;
                          _showMessage(
                              'API unavailable. Start backend or use demo payment.');
                        }
                      },
                      child: const Text('Create test order')),
                  FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => _cart.clear());
                        _showMessage(
                            'Test payment successful. Order confirmed!');
                      },
                      icon: const Icon(Icons.lock_outline),
                      label: const Text('Pay securely'))
                ]));
  }

  void _showSearch() {
    final controller = TextEditingController(text: _searchQuery);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Find your ritual'),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (_) {
            setState(() {
              _searchQuery = controller.text.trim();
              _selectedTab = 1;
            });
            Navigator.pop(context);
          },
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Soap, mask, pickle...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                setState(() {
                  _searchQuery = controller.text.trim();
                  _selectedTab = 1;
                });
                Navigator.pop(context);
              },
              child: const Text('Search')),
        ],
      ),
    );
  }

  void _showStory() => _showMessage(
      'Satpara Naturals makes small-batch, handmade skincare in Maharashtra.');
  void _showContact() =>
      _showMessage('WhatsApp: +91 95036 74001  |  connect@satparanaturals.com');
  void _showMessage(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}

class _DemoProduct {
  final String name;
  final String subtitle;
  final int price;
  final int mrp;
  final String image;
  final String category;
  final String slug;
  const _DemoProduct(this.name, this.subtitle, this.price, this.mrp, this.image,
      this.category, this.slug);
}

class _ConcernTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ConcernTile(this.title, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF21392B), size: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w800))),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _DemoAuthDialog extends StatelessWidget {
  final VoidCallback onSuccess;
  const _DemoAuthDialog({required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Welcome to Satpara'),
      content: const Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(decoration: InputDecoration(labelText: 'Email')),
        SizedBox(height: 12),
        TextField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true)
      ]),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onSuccess();
            },
            child: const Text('Continue in demo'))
      ],
    );
  }
}

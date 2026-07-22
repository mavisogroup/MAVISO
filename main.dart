import 'package:flutter/material.dart';

void main() => runApp(const MavisoApp());

class MavisoApp extends StatelessWidget {
  const MavisoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAVISO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F4EE),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE8612B)),
      ),
      home: const WelcomePage(),
    );
  }
}

class Product {
  final String name, merchant, emoji, eta, category;
  final int price;
  final bool promo;
  const Product(this.name, this.merchant, this.emoji, this.price, this.eta, this.category, {this.promo = false});
}

const products = [
  Product('Double Smash', 'KOBSY', '🍔', 60000, '18–25 min', 'Restaurant', promo: true),
  Product('Poulet braisé', 'Restaurant Délice', '🍗', 85000, '22–30 min', 'Restaurant'),
  Product('Pizza Pepperoni', 'La Terrasse', '🍕', 95000, '25–35 min', 'Restaurant', promo: true),
  Product('Pack eau minérale', 'Market Plus', '💧', 45000, '15–22 min', 'Supermarché'),
];

String money(int value) {
  final digits = value.toString();
  final b = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) b.write(' ');
    b.write(digits[i]);
  }
  return '${b.toString()} GNF';
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  void open(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('MAVISO', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
            const Text('DELIVERY', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2.2)),
            const Spacer(),
            const Text('Tout ce que vous aimez, livré.', style: TextStyle(color: Colors.white, fontSize: 44, height: 1, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            const Text('Restaurants et supermarchés autour de vous, au même prix qu’en magasin.', style: TextStyle(color: Colors.white70, height: 1.5)),
            const SizedBox(height: 28),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: () => open(context, const AuthPage(title: 'Créer un compte')), style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE8612B), padding: const EdgeInsets.all(17)), child: const Text('Créer un compte'))),
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => open(context, const AuthPage(title: 'Se connecter')), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38), padding: const EdgeInsets.all(17)), child: const Text('Se connecter'))),
            SizedBox(width: double.infinity, child: TextButton(onPressed: () => open(context, const HomePage()), style: TextButton.styleFrom(foregroundColor: Colors.white, padding: const EdgeInsets.all(17)), child: const Text('Continuer en tant qu’invité'))),
          ]),
        ),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  final String title;
  const AuthPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final signup = title.contains('Créer');
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 20),
        if (signup) const TextField(decoration: InputDecoration(labelText: 'Nom complet', filled: true, fillColor: Colors.white)),
        if (signup) const SizedBox(height: 12),
        const TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: '+224 6XX XX XX XX', filled: true, fillColor: Colors.white)),
        const SizedBox(height: 18),
        FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OtpPage())), style: FilledButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.all(17)), child: const Text('Continuer')),
      ]),
    );
  }
}

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Entrez le code reçu', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        const TextField(maxLength: 6, textAlign: TextAlign.center, keyboardType: TextInputType.number, style: TextStyle(fontSize: 24, letterSpacing: 10), decoration: InputDecoration(hintText: '••••••', filled: true, fillColor: Colors.white, counterText: '')),
        const SizedBox(height: 18),
        FilledButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (_) => false), style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE8612B), padding: const EdgeInsets.all(17)), child: const Text('Valider et accéder à MAVISO')),
      ]),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '', category = 'Tous', point = 'Définir mon Point MAVISO';
  final cart = <Product>[];

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) {
      final q = query.toLowerCase();
      final matchQ = q.isEmpty || p.name.toLowerCase().contains(q) || p.merchant.toLowerCase().contains(q);
      final matchC = category == 'Tous' || (category == 'Promotions' ? p.promo : p.category == category);
      return matchQ && matchC;
    }).toList();
    return Scaffold(
      bottomNavigationBar: const NavigationBar(selectedIndex: 0, destinations: [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Accueil'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Explorer'),
        NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Commandes'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
      ]),
      floatingActionButton: cart.isEmpty ? null : FloatingActionButton.extended(backgroundColor: const Color(0xFF1D6B53), foregroundColor: Colors.white, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(items: cart))), label: Text('${cart.length} article(s)'), icon: const Icon(Icons.shopping_bag_outlined)),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Container(padding: const EdgeInsets.fromLTRB(20,24,20,28), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF111111), Color(0xFF292929)]), borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))), child: SafeArea(bottom: false, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('MAVISO', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)), Text('DELIVERY', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2.2))]), CircleAvatar(backgroundColor: Color(0xFFE8612B), child: Text('WS', style: TextStyle(color: Colors.white)))]),
          const SizedBox(height:18),
          InkWell(onTap: () async { final v = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const PointPage())); if(v != null) setState(() => point = v); }, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)), child: Row(children: [const Icon(Icons.location_on_outlined, color: Colors.white), const SizedBox(width:8), Expanded(child: Text(point, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))), const Icon(Icons.chevron_right, color: Colors.white)]))),
          const SizedBox(height:22),
          const Text('Qu’est-ce qui vous ferait plaisir ?', style: TextStyle(color: Colors.white, fontSize: 30, height: 1.05, fontWeight: FontWeight.w900)),
          const SizedBox(height:8),
          const Text('Les produits disponibles autour de votre zone.', style: TextStyle(color: Colors.white70)),
        ])))),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(18), child: TextField(onChanged: (v) => setState(() => query = v), decoration: InputDecoration(hintText: 'Burger, poulet, riz, eau...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none))))),
        SliverToBoxAdapter(child: SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:18), child: Row(children: ['Tous','Restaurant','Supermarché','Promotions'].map((item) => Padding(padding: const EdgeInsets.only(right:8), child: ChoiceChip(label: Text(item), selected: category == item, onSelected: (_) => setState(() => category = item)))).toList()))),
        const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(18,20,18,12), child: Text('Produits près de vous', style: TextStyle(fontSize:20, fontWeight: FontWeight.w900)))),
        SliverPadding(padding: const EdgeInsets.fromLTRB(18,0,18,120), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context,index) { final p = filtered[index]; return ProductCard(product: p, onTap: () async { final add = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => ProductPage(product:p))); if(add == true) setState(() => cart.add(p)); }); }, childCount: filtered.length), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:13,mainAxisSpacing:13,childAspectRatio:.67))),
      ]),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product; final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.white, elevation: 2, borderRadius: BorderRadius.circular(20), child: InkWell(borderRadius: BorderRadius.circular(20), onTap:onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Stack(children:[Container(width:double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors:[Color(0xFFF5D9CA),Color(0xFFFBF1EB)]), borderRadius: BorderRadius.vertical(top: Radius.circular(20))), child: Center(child: Text(product.emoji, style: const TextStyle(fontSize:56)))), if(product.promo) Positioned(top:10,left:10,child:Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:5),decoration:BoxDecoration(color:const Color(0xFFE8612B),borderRadius:BorderRadius.circular(99)),child:const Text('PROMO',style:TextStyle(color:Colors.white,fontSize:10,fontWeight:FontWeight.w900))))])),
      Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(product.name,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w900)),Text(product.merchant,style:const TextStyle(color:Colors.black54,fontSize:11)),const SizedBox(height:7),Text(money(product.price),style:const TextStyle(fontWeight:FontWeight.w900)),Text('🛵 ${product.eta}',style:const TextStyle(color:Color(0xFF1D6B53),fontSize:10,fontWeight:FontWeight.w800))]))
    ])));
  }
}

class ProductPage extends StatelessWidget {
  final Product product; const ProductPage({super.key, required this.product});
  @override
  Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('Produit')), body:ListView(padding:const EdgeInsets.all(18),children:[Container(height:230,decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFFF5D9CA),Color(0xFFFBF1EB)]),borderRadius:BorderRadius.circular(26)),child:Center(child:Text(product.emoji,style:const TextStyle(fontSize:96)))),const SizedBox(height:16),Text(product.name,style:const TextStyle(fontSize:26,fontWeight:FontWeight.w900)),Text('${product.merchant} · ${product.eta}',style:const TextStyle(color:Colors.black54)),const SizedBox(height:14),Text(money(product.price),style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)),const SizedBox(height:14),const Text('Même prix qu’en magasin. Les frais de livraison sont calculés séparément.',style:TextStyle(color:Colors.black54)),const SizedBox(height:24),FilledButton(onPressed:()=>Navigator.pop(context,true),style:FilledButton.styleFrom(backgroundColor:const Color(0xFFE8612B),padding:const EdgeInsets.all(17)),child:Text('Ajouter · ${money(product.price)}'))]));
}

class PointPage extends StatelessWidget {
  const PointPage({super.key});
  @override
  Widget build(BuildContext context) {
    final name=TextEditingController(), landmark=TextEditingController();
    return Scaffold(appBar:AppBar(title:const Text('Point MAVISO')),body:ListView(padding:const EdgeInsets.all(20),children:[const Text('Où souhaitez-vous être livré ?',style:TextStyle(fontSize:26,fontWeight:FontWeight.w900)),const SizedBox(height:8),const Text('Votre position GPS suffit. Le repère reste facultatif.',style:TextStyle(color:Colors.black54)),const SizedBox(height:18),Container(height:180,decoration:BoxDecoration(color:const Color(0xFFDCE8E1),borderRadius:BorderRadius.circular(22)),child:const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.location_pin,size:54,color:Color(0xFFE8612B)),Text('Carte GPS — Conakry')]))),const SizedBox(height:16),OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.my_location),label:const Text('Utiliser ma position actuelle')),const SizedBox(height:12),TextField(controller:name,decoration:const InputDecoration(labelText:'Nom : Maison, Bureau...',filled:true,fillColor:Colors.white)),const SizedBox(height:12),TextField(controller:landmark,decoration:const InputDecoration(labelText:'Repère facultatif',filled:true,fillColor:Colors.white)),const SizedBox(height:18),FilledButton(onPressed:(){final p=name.text.trim().isEmpty?'Maison':name.text.trim();Navigator.pop(context,landmark.text.trim().isEmpty?p:'$p · ${landmark.text.trim()}');},style:FilledButton.styleFrom(backgroundColor:Colors.black,padding:const EdgeInsets.all(17)),child:const Text('Créer mon Point MAVISO'))]));
  }
}

class CartPage extends StatelessWidget {
  final List<Product> items; const CartPage({super.key, required this.items});
  @override
  Widget build(BuildContext context) {final subtotal=items.fold<int>(0,(s,i)=>s+i.price), total=subtotal+15000;return Scaffold(appBar:AppBar(title:const Text('Votre panier')),body:ListView(padding:const EdgeInsets.all(18),children:[...items.map((i)=>Card(elevation:0,color:Colors.white,child:ListTile(leading:Text(i.emoji,style:const TextStyle(fontSize:32)),title:Text(i.name,style:const TextStyle(fontWeight:FontWeight.w900)),subtitle:Text(i.merchant),trailing:Text(money(i.price))))),Card(elevation:0,color:Colors.white,child:ListTile(title:const Text('Livraison'),trailing:Text(money(15000)))),const SizedBox(height:18),Text('Total : ${money(total)}',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900)),const SizedBox(height:18),FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>TrackingPage(total:total))),style:FilledButton.styleFrom(backgroundColor:const Color(0xFFE8612B),padding:const EdgeInsets.all(17)),child:const Text('Commander'))]));}
}

class TrackingPage extends StatelessWidget {
  final int total; const TrackingPage({super.key, required this.total});
  @override
  Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Suivi')),body:ListView(padding:const EdgeInsets.all(18),children:[const Text('Commande #MV-2048',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),Text('Total : ${money(total)}'),const SizedBox(height:18),const Card(elevation:0,color:Colors.white,child:Column(children:[ListTile(leading:Icon(Icons.check_circle,color:Color(0xFF1D6B53)),title:Text('Commande acceptée')),ListTile(leading:Icon(Icons.check_circle,color:Color(0xFF1D6B53)),title:Text('En préparation')),ListTile(leading:Icon(Icons.delivery_dining),title:Text('Livreur trouvé'),subtitle:Text('Mamadou · ⭐ 4,9 · Moto noire')),ListTile(leading:Icon(Icons.radio_button_unchecked),title:Text('En route vers vous'))]))]));
}

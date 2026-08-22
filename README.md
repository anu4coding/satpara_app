# Satpara Naturals — Flutter App

A Flutter (Android + iOS) e-commerce app for **satparanaturals.com**
(natural handmade soaps, face masks & pickles), backed by **Firebase
Auth** + **Cloud Firestore**.

## 1. Project structure

```
lib/
  main.dart                 # App entry, wires up Providers
  firebase_options.dart     # placeholder — regenerate with flutterfire configure
  domain/models/            # Plain Dart data models (Product, Category, Cart, Order, User)
  backend/                  # Raw Firebase calls (FirestoreService, AuthService)
  repository/               # App-level logic on top of backend/ (what screens call)
  providers/                # ChangeNotifier state (Provider package)
  screens/                  # One file per screen
  widgets/                  # Reusable UI pieces (ProductCard, CategoryCard)
  utils/                    # theme.dart (colors/fonts), constants.dart
firestore.rules             # Security rules — copy into Firebase Console
seed/seed_firestore.js      # Node script to push starter products into Firestore
```

This mirrors clean-architecture layering:
**screens → providers → repository → backend → Firebase**.
Screens never touch Firestore directly — easy to unit test or swap later.

## 2. Prerequisites

- Flutter SDK ≥ 3.3 (`flutter --version`)
- A Firebase project (free Spark plan is fine to start)
- Node.js (only for the optional seed script)

## 3. Create the Flutter project & drop these files in

```bash
flutter create satpara_naturals
cd satpara_naturals
# now copy pubspec.yaml and the lib/ folder from this package over yours
flutter pub get
```

## 4. Connect Firebase

```bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```

- Pick/create your Firebase project (e.g. `satpara-naturals-app`)
- Select Android + iOS
- This **overwrites `lib/firebase_options.dart`** with your real keys and
  generates `android/app/google-services.json` and
  `ios/Runner/GoogleService-Info.plist` automatically. Don't hand-edit
  those files.

In the Firebase Console, enable:
- **Authentication → Sign-in method → Email/Password**
- **Firestore Database → Create database** (start in production mode)
- Paste the contents of `firestore.rules` into **Firestore → Rules** and publish.

## 5. Firestore data model

```
categories/{categoryId}
  name, parentId, imageUrl

products/{productId}
  name, description, price, mrp, categoryId, categoryName,
  images[], stock, rating, reviewCount,
  isFeatured, isBestseller, isNewArrival, tags[], createdAt

users/{uid}
  name, email, phone, address
  cart/{productId}        -> name, image, price, quantity
  orders/{orderId}        -> mirrors top-level orders/{orderId}

orders/{orderId}
  userId, items[], totalAmount, address, phone, paymentMethod, status, createdAt
```

## 6. Seed starter products (optional but recommended)

```bash
cd seed
npm init -y
npm install firebase-admin
```

Firebase Console → Project Settings → Service Accounts → **Generate new
private key** → save as `seed/serviceAccountKey.json` (keep this out of
git — add it to `.gitignore`). Then:

```bash
node seed_firestore.js
```

This pushes the categories (Skin Care/Soap, Face Mask, Food/Pickle) and
10 starter products (Rose Soap, Goat Milk Soap, Haldi Chandan Kesar
Soap, Turmeric Pickle, etc.) with **empty `images` arrays** — upload
your own product photos to Firebase Storage (or keep your existing CDN
URLs) and update each product's `images` field in the Firestore
console, or add an `imageUrl` when you write the seed data.

## 7. Run it

```bash
flutter run
```

## 8. What's already wired up

- Email/password signup & login (`AuthProvider`, `LoginScreen`, `SignupScreen`)
- Home screen: banner, categories, bestsellers, new arrivals, all products
  (all live-streamed from Firestore, so admin edits reflect instantly)
- Category browsing, product detail with quantity picker
- Realtime cart stored per-user in Firestore (survives app reinstall/login
  on another device)
- Checkout → COD or "Online" placeholder → writes an order doc
- Order history screen

## 9. What you'll still want to add

- **Payments**: `paymentMethod: 'ONLINE'` is a stub — integrate
  Razorpay/Stripe/UPI intents when ready.
- **Push notifications** for order status (Firebase Cloud Messaging).
- **Admin panel**: right now products are managed via Firebase Console
  or the seed script — consider a small internal web admin later, or a
  Cloud Function that syncs from your existing Shopify/QPe storefront.
- **Product images**: point the `images` array at real photo URLs
  (Firebase Storage or your existing CDN).
- **Search**: current search is a simple client-side filter; swap in
  Algolia/Typesense if your catalog grows large.
- App icons, splash screen assets, and store listing assets.

## 10. Why this structure

Given you're already comfortable with Dart/Flutter fundamentals, this
follows the same `backend / domain / repository` split visible in your
existing project screenshot, just filled in end-to-end: `backend/` has
zero business logic (pure Firebase calls), `repository/` is what the
rest of the app talks to, and `providers/` hold UI state — so you can
learn one layer at a time without rewriting the others.

## 11. Real payment development

The `backend/` folder contains a small Node/Express API. Razorpay secrets
must stay there, never in Flutter or the browser.

```bash
cd backend
copy .env.example .env
npm install
# Put your Razorpay TEST key ID and secret in .env
npm run dev
```

Run Flutter with the API URL:

```bash
flutter pub get
flutter run -d chrome --dart-define=PAYMENT_API_URL=http://localhost:8787
```

The demo checkout's **Create test order** button calls
`POST /api/payments/orders`. The server also exposes
`POST /api/payments/verify` and a signed webhook endpoint. A real Razorpay
Checkout widget still needs to be added next: use Razorpay Checkout JS for
web and the official Razorpay Flutter/native SDK for Android and iOS, then
send its success payload to `/api/payments/verify` before creating the order
in Firestore.

Razorpay has no mandatory setup fee, but live transactions have gateway
charges. Firebase's free tier can host auth and Firestore during early
development; deploy this API to a free-tier Node host and set a production
`PAYMENT_API_URL` for release builds.

The website catalog should be connected through an official API/export from
your QPe/site provider. `SITE_CATALOG_URL` is reserved for that adapter;
scraping the public HTML is intentionally not used because it is fragile and
can break product prices, stock, or terms.

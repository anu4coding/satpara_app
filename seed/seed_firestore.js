/**
 * One-time script to seed Firestore with categories & starter products
 * pulled from satparanaturals.com's public storefront (name/price only —
 * write your own descriptions & re-host images you have rights to).
 *
 * SETUP:
 *   1. cd seed
 *   2. npm init -y && npm install firebase-admin
 *   3. Go to Firebase Console > Project Settings > Service Accounts >
 *      "Generate new private key" and save it as serviceAccountKey.json
 *      in this same /seed folder (DO NOT commit this file to git).
 *   4. node seed_firestore.js
 */

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const categories = [
  { id: 'skin-care', name: 'Skin Care', parentId: '', imageUrl: '' },
  { id: 'soap', name: 'Soap', parentId: 'skin-care', imageUrl: '' },
  { id: 'face-mask', name: 'Face Mask', parentId: 'skin-care', imageUrl: '' },
  { id: 'food', name: 'Food', parentId: '', imageUrl: '' },
  { id: 'pickle', name: 'Pickle', parentId: 'food', imageUrl: '' },
];

const products = [
  {
    id: 'rose-soap',
    name: 'Rose Soap',
    description: 'Handmade herbal soap infused with rose for gentle, glowing skin.',
    price: 70, mrp: 75,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 100, isBestseller: true, isNewArrival: true,
    tags: ['handmade', 'chemical-free'],
  },
  {
    id: 'orange-soap',
    name: 'Orange Soap',
    description: 'Citrus-refreshed handmade soap that brightens and revitalizes skin.',
    price: 60, mrp: 65,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 100, isBestseller: true,
    tags: ['handmade', 'chemical-free'],
  },
  {
    id: 'goat-milk-soap',
    name: 'Goat Milk Soap',
    description: 'Nourishing goat milk soap for soft, hydrated, healthy-looking skin.',
    price: 75, mrp: 80,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 100, isBestseller: true,
    tags: ['handmade', 'chemical-free'],
  },
  {
    id: 'rice-mulethi-olive-oil-soap',
    name: 'Rice, Mulethi & Olive Oil Soap',
    description: 'A brightening blend of rice, mulethi (licorice) and olive oil.',
    price: 100, mrp: 140,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 100, isBestseller: true,
    tags: ['handmade', 'brightening'],
  },
  {
    id: 'shea-butter-soap',
    name: 'Shea Butter Soap',
    description: 'Deeply moisturizing soap crafted with pure shea butter.',
    price: 80, mrp: 120,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 100, isNewArrival: true,
    tags: ['handmade', 'moisturizing'],
  },
  {
    id: 'neem-tulsi-aloe-vera-soap',
    name: 'Neem Tulsi Aloe Vera Soap',
    description: 'Purifying soap with neem, tulsi and aloe vera for clear skin.',
    price: 65, mrp: 99,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 100, isNewArrival: true,
    tags: ['handmade', 'clarifying'],
  },
  {
    id: 'haldi-chandan-kesar-soap',
    name: 'Haldi Chandan Kesar Soap',
    description: 'Traditional turmeric, sandalwood & saffron soap to help remove tan.',
    price: 80, mrp: 100,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 100, isNewArrival: true, isFeatured: true,
    tags: ['handmade', 'tan-removal'],
  },
  {
    id: 'neem-soap-combo-4pack',
    name: 'Neem Soap Combo (Pack of 4, 400g)',
    description: 'Value pack of 4 neem soaps for the whole family.',
    price: 250, mrp: 260,
    categoryId: 'soap', categoryName: 'Soap',
    images: [], stock: 50,
    tags: ['handmade', 'combo'],
  },
  {
    id: 'satpara-face-mask-glow',
    name: 'Satpara Face Mask – Natural Glow Face Pack',
    description: 'Natural face pack formulated to reveal healthy, glowing skin.',
    price: 150, mrp: 299,
    categoryId: 'face-mask', categoryName: 'Face Mask',
    images: [], stock: 60, isFeatured: true, isNewArrival: true,
    tags: ['face-mask', 'glow'],
  },
  {
    id: 'turmeric-pickle-180g',
    name: 'Satpara Naturals Turmeric Pickle - 180g',
    description: 'Traditional homemade-style turmeric pickle, 180g jar.',
    price: 250, mrp: 300,
    categoryId: 'pickle', categoryName: 'Pickle',
    images: [], stock: 40, isFeatured: true,
    tags: ['food', 'pickle'],
  },
];

async function seed() {
  const batch = db.batch();

  categories.forEach((cat) => {
    const { id, ...data } = cat;
    batch.set(db.collection('categories').doc(id), data);
  });

  products.forEach((p) => {
    const { id, ...data } = p;
    batch.set(db.collection('products').doc(id), {
      ...data,
      rating: 4.5,
      reviewCount: 0,
      isFeatured: data.isFeatured || false,
      isBestseller: data.isBestseller || false,
      isNewArrival: data.isNewArrival || false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  await batch.commit();
  console.log(`Seeded ${categories.length} categories and ${products.length} products.`);
}

seed().catch(console.error);

import crypto from 'node:crypto';
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import Razorpay from 'razorpay';

dotenv.config();

const app = express();
const port = Number(process.env.PORT || 8787);
const allowedOrigins = (process.env.ALLOWED_ORIGINS || '*').split(',').map((origin) => origin.trim());
const razorpay = process.env.RAZORPAY_KEY_ID && process.env.RAZORPAY_KEY_SECRET
  ? new Razorpay({ key_id: process.env.RAZORPAY_KEY_ID, key_secret: process.env.RAZORPAY_KEY_SECRET })
  : null;

app.use(cors({ origin: allowedOrigins.includes('*') ? true : allowedOrigins }));

app.get('/health', (_req, res) => res.json({ ok: true, service: 'satpara-naturals-api' }));

app.post('/api/payments/webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const signature = req.headers['x-razorpay-signature'];
  const secret = process.env.RAZORPAY_WEBHOOK_SECRET;
  if (!secret || !signature) return res.status(400).json({ error: 'Webhook secret or signature missing.' });
  const expected = crypto.createHmac('sha256', secret).update(req.body).digest('hex');
  if (expected !== signature) return res.status(400).json({ error: 'Invalid webhook signature.' });
  // Persist payment/order status in Firestore here in production.
  res.json({ received: true });
});

app.use(express.json({ limit: '100kb' }));

app.post('/api/payments/orders', async (req, res) => {
  if (!razorpay) return res.status(503).json({ error: 'Razorpay is not configured on the server.' });
  const { amount, currency = 'INR', receipt } = req.body ?? {};
  if (!Number.isInteger(amount) || amount < 100) return res.status(400).json({ error: 'amount must be an integer in paise and at least 100.' });
  try {
    const order = await razorpay.orders.create({ amount, currency, receipt: receipt || `satpara_${Date.now()}`, payment_capture: 1 });
    res.json({ id: order.id, amount: order.amount, currency: order.currency, keyId: process.env.RAZORPAY_KEY_ID });
  } catch (error) {
    res.status(502).json({ error: 'Could not create Razorpay order.', detail: error.message });
  }
});

app.post('/api/payments/verify', (req, res) => {
  const { razorpay_order_id: orderId, razorpay_payment_id: paymentId, razorpay_signature: signature } = req.body ?? {};
  if (!orderId || !paymentId || !signature || !process.env.RAZORPAY_KEY_SECRET) return res.status(400).json({ verified: false, error: 'Missing payment verification fields.' });
  const expected = crypto.createHmac('sha256', process.env.RAZORPAY_KEY_SECRET).update(`${orderId}|${paymentId}`).digest('hex');
  const expectedBytes = Buffer.from(expected);
  const actualBytes = Buffer.from(signature);
  const verified = expectedBytes.length === actualBytes.length && crypto.timingSafeEqual(expectedBytes, actualBytes);
  res.status(verified ? 200 : 400).json({ verified });
});

app.listen(port, () => console.log(`Satpara API listening on http://localhost:${port}`));
